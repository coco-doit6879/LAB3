import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:deadline_mate/services/file_storage_service.dart';

void main() {
  final pdf = Uint8List.fromList(utf8.encode('%PDF-1.4 test fixture'));
  test('unsigned upload sends PDF and preset without secrets and validates response', () async {
    var calls = 0;
    final progress = <double>[];
    final storage = CloudinaryFileStorage(
      cloudName: 'test-cloud',
      uploadPreset: 'pdf-only',
      clientFactory: () => MockClient((request) async {
        calls++;
        expect(
          request.url.toString(),
          'https://api.cloudinary.com/v1_1/test-cloud/raw/upload',
        );
        expect(request.body, contains('pdf-only'));
        expect(request.body, contains('application/pdf'));
        expect(request.body, isNot(contains('api_secret')));
        expect(request.body, isNot(contains('signature')));
        return http.Response(
          jsonEncode({
            'secure_url': 'https://res.cloudinary.com/test-cloud/raw/upload/v1/report.pdf',
            'public_id': 'report.pdf',
            'resource_type': 'raw',
          }),
          200,
        );
      }),
    );
    final result = await storage.uploadPdf(pdf, 'report.pdf', progress.add);
    expect(result.provider, 'cloudinary');
    expect(result.objectPath, 'report.pdf');
    expect(calls, 1);
    expect(progress.last, 1);
  });
  test(
    'missing configuration and invalid PDF fail before any HTTP request',
    () async {
      var calls = 0;
      http.Client client() => MockClient((_) async {
        calls++;
        return http.Response('{}', 500);
      });
      final missing = CloudinaryFileStorage(
        cloudName: '',
        uploadPreset: '',
        clientFactory: client,
      );
      await expectLater(
        missing.uploadPdf(pdf, 'report.pdf', (_) {}),
        throwsA(isA<StorageConfigurationException>()),
      );
      final configured = CloudinaryFileStorage(
        cloudName: 'test',
        uploadPreset: 'pdf-only',
        clientFactory: client,
      );
      await expectLater(
        configured.uploadPdf(Uint8List(1), 'report.pdf', (_) {}),
        throwsArgumentError,
      );
      expect(calls, 0);
    },
  );
  test('failed uploads and untrusted response URLs cannot become stored report links', () async {
    for (final response in [
      http.Response('{}', 400),
      http.Response(
        jsonEncode({
          'secure_url': 'https://evil.example/test/raw/upload/report.pdf',
          'public_id': 'report',
          'resource_type': 'raw',
        }),
        200,
      ),
    ]) {
      final storage = CloudinaryFileStorage(
        cloudName: 'test',
        uploadPreset: 'pdf-only',
        clientFactory: () => MockClient((_) async => response),
      );
      await expectLater(
        storage.uploadPdf(pdf, 'report.pdf', (_) {}),
        response.statusCode == 400 ? throwsStateError : throwsFormatException,
      );
    }
  });
}
