import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/study_session.dart';

abstract interface class StudyRepository {
  String allocateId();
  Stream<List<StudySession>> watch();
  Future<void> plan(String id, String title, DateTime plannedAt, int minutes);
  Future<void> start(String id);
  Future<void> finish(String id);
}

class FirestoreStudyService implements StudyRepository {
  FirestoreStudyService(String uid)
    : _sessions = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('study_sessions');
  final CollectionReference<Map<String, dynamic>> _sessions;
  static const _timeout = Duration(seconds: 20);
  @override
  String allocateId() => _sessions.doc().id;
  @override
  Stream<List<StudySession>> watch() => _sessions
      .orderBy('plannedAt')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) {
              final d = doc.data();
              return StudySession(
                id: doc.id,
                title: d['title'] as String,
                plannedAt: (d['plannedAt'] as Timestamp).toDate(),
                plannedMinutes: d['plannedMinutes'] as int,
                status: SessionStatus.values.byName(d['status'] as String),
                startedAt: (d['startedAt'] as Timestamp?)?.toDate(),
                endedAt: (d['endedAt'] as Timestamp?)?.toDate(),
              );
            })
            .toList(growable: false),
      );
  @override
  Future<void> plan(String id, String title, DateTime plannedAt, int minutes) {
    if (id.isEmpty) throw ArgumentError('Session draft ID required');
    final ref = _sessions.doc(id);
    return _sessions.firestore.runTransaction(
      (transaction) async {
        final existing = await transaction.get(ref);
        if (existing.exists) {
          final data = existing.data()!;
          // An acknowledged retry must not create a second session or rewind state.
          if (data['title'] != title.trim() ||
              data['plannedAt'] != Timestamp.fromDate(plannedAt) ||
              data['plannedMinutes'] != minutes) {
            throw StateError('Draft already saved with different values');
          }
          return;
        }
        transaction.set(ref, {
          'title': title.trim(),
          'plannedAt': Timestamp.fromDate(plannedAt),
          'plannedMinutes': minutes,
          'status': 'planned',
          'startedAt': null,
          'endedAt': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      },
      timeout: _timeout,
      maxAttempts: 3,
    );
  }

  @override
  Future<void> start(String id) =>
      _transition(id, 'planned', 'running', 'startedAt');
  @override
  Future<void> finish(String id) =>
      _transition(id, 'running', 'completed', 'endedAt');
  Future<void> _transition(
    String id,
    String from,
    String to,
    String timeField,
  ) async {
    final ref = _sessions.doc(id);
    await _sessions.firestore.runTransaction(
      (transaction) async {
        final doc = await transaction.get(ref);
        if (!doc.exists || doc.data()?['status'] != from) {
          throw StateError('Phiên học đã đổi trạng thái. Hãy tải lại.');
        }
        transaction.update(ref, {
          'status': to,
          timeField: FieldValue.serverTimestamp(),
        });
      },
      timeout: _timeout,
      maxAttempts: 3,
    );
  }
}
