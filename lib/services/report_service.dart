import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

import '../models/deadline.dart';
import '../models/report.dart';

abstract interface class ReportRepository {
  Stream<List<Report>> watch();
  Future<void> export(List<Deadline> items, void Function(double) onProgress);
  Future<void> open(String url);
}

class FirebaseReportService implements ReportRepository {
  FirebaseReportService(this.uid);
  final String uid;
  CollectionReference<Map<String, dynamic>> get _reports => FirebaseFirestore
      .instance
      .collection('users')
      .doc(uid)
      .collection('reports');
  @override
  Stream<List<Report>> watch() => _reports
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data();
              return Report(
                id: doc.id,
                fileName: data['fileName'] as String,
                url: data['url'] as String,
                createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
                itemCount: data['itemCount'] as int,
              );
            })
            .toList(growable: false),
      );
  @override
  Future<void> export(
    List<Deadline> items,
    void Function(double) onProgress,
  ) async {
    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (_) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Deadline Mate',
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#183D47'),
              ),
            ),
          ),
          pw.Text('Báo cáo deadline · ${DateTime.now().toIso8601String()}'),
          pw.SizedBox(height: 16),
          pw.Text(
            'Tổng: ${items.length} · Hoàn thành: ${items.where((item) => item.completed).length}',
          ),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: ['Deadline', 'Môn học', 'Hạn', 'Trạng thái'],
            data: items
                .map(
                  (item) => [
                    item.title,
                    item.courseId,
                    '${item.dueAt.day}/${item.dueAt.month}/${item.dueAt.year}',
                    item.completed ? 'Đã xong' : 'Chưa xong',
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );
    final bytes = await pdf.save();
    final doc = _reports.doc();
    final fileName = 'deadline-mate-${doc.id}.pdf';
    final objectPath = 'reports/$uid/$fileName';
    final ref = FirebaseStorage.instance.ref(objectPath);
    final task = ref.putData(
      bytes,
      SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {'ownerId': uid},
      ),
    );
    final subscription = task.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0) {
        onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
      }
    });
    try {
      await task;
      final url = await ref.getDownloadURL();
      try {
        await doc.set({
          'fileName': fileName,
          'url': url,
          'ownerId': uid,
          'createdAt': FieldValue.serverTimestamp(),
          'itemCount': items.length,
          'objectPath': objectPath,
        });
      } catch (_) {
        // Best-effort cleanup prevents an untracked PDF after a metadata failure.
        try {
          await ref.delete();
        } catch (_) {
          /* Record remediation in Firebase Console if cleanup fails. */
        }
        rethrow;
      }
    } finally {
      await subscription.cancel();
    }
  }

  @override
  Future<void> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host != 'firebasestorage.googleapis.com') {
      throw ArgumentError('Unsupported report URL');
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw StateError('Cannot open PDF');
    }
  }
}
