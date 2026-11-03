import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class StorageConfigurationException implements Exception {
  const StorageConfigurationException();
}

class StoredPdf {
  const StoredPdf({
    required this.url,
    required this.objectPath,
    required this.provider,
  });
  final String url;
  final String objectPath;
  final String provider;
}

abstract interface class FileStorageService {
  bool get configured;
  Future<StoredPdf> uploadPdf(
    Uint8List bytes,
    String fileName,
    void Function(double) onProgress,
  );
}

class CloudinaryFileStorage implements FileStorageService {
  CloudinaryFileStorage({
    required this.cloudName,
    required this.uploadPreset,
    http.Client Function()? clientFactory,
  }) : _clientFactory = clientFactory ?? http.Client.new;
  factory CloudinaryFileStorage.fromEnvironment() => CloudinaryFileStorage(
    cloudName: const String.fromEnvironment('CLOUDINARY_CLOUD_NAME'),
    uploadPreset: const String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET'),
  );
  final String cloudName;
  final String uploadPreset;
  final http.Client Function() _clientFactory;
  static const maxBytes = 10 * 1024 * 1024;
  @override
  bool get configured =>
      RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(cloudName) &&
      uploadPreset.isNotEmpty;
  @override
  Future<StoredPdf> uploadPdf(
    Uint8List bytes,
    String fileName,
    void Function(double) onProgress,
  ) async {
    if (!configured) throw const StorageConfigurationException();
    if (bytes.length < 5 ||
        bytes.length > maxBytes ||
        utf8.decode(bytes.take(5).toList(), allowMalformed: true) != '%PDF-') {
      throw ArgumentError('A PDF up to 10 MiB is required');
    }
    final client = _clientFactory();
    try {
      final request =
          _ProgressMultipartRequest(
              'POST',
              Uri.https('api.cloudinary.com', '/v1_1/$cloudName/raw/upload'),
              onProgress,
            )
            ..fields['upload_preset'] = uploadPreset
            ..files.add(
              http.MultipartFile.fromBytes(
                'file',
                bytes,
                filename: fileName,
                contentType: MediaType('application', 'pdf'),
              ),
            );
      // Unsigned upload only: no API key, API secret, signature or remote file URL.
      final response = await http.Response.fromStream(
        await client.send(request).timeout(const Duration(seconds: 45)),
      ).timeout(const Duration(seconds: 45));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError('PDF upload rejected (${response.statusCode})');
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final uri = Uri.tryParse(data['secure_url'] as String? ?? '');
      final objectPath = data['public_id'];
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host != 'res.cloudinary.com' ||
          uri.userInfo.isNotEmpty ||
          uri.port != 443 ||
          uri.pathSegments.length < 4 ||
          uri.pathSegments[0] != cloudName ||
          uri.pathSegments[1] != 'raw' ||
          uri.pathSegments[2] != 'upload' ||
          data['resource_type'] != 'raw' ||
          objectPath is! String ||
          objectPath.isEmpty ||
          objectPath.length > 1024) {
        throw const FormatException('Invalid Cloudinary upload response');
      }
      return StoredPdf(
        url: uri.toString(),
        objectPath: objectPath,
        provider: 'cloudinary',
      );
    } finally {
      client.close();
    }
  }
}

class _ProgressMultipartRequest extends http.MultipartRequest {
  _ProgressMultipartRequest(super.method, super.url, this.onProgress);
  final void Function(double) onProgress;
  @override
  http.ByteStream finalize() {
    final stream = super.finalize();
    final total = contentLength;
    var sent = 0;
    return http.ByteStream(
      stream.map((chunk) {
        sent += chunk.length;
        onProgress((sent / total).clamp(0.0, 1.0));
        return chunk;
      }),
    );
  }
}
