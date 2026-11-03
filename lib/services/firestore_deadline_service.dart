import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/deadline.dart';
import 'deadline_repository.dart';

class FirestoreDeadlineService implements DeadlineRepository {
  FirestoreDeadlineService({required String uid, FirebaseFirestore? firestore})
    : _items = (firestore ?? FirebaseFirestore.instance)
          .collection('users')
          .doc(uid)
          .collection('deadlines') {
    if (uid.isEmpty) throw ArgumentError.value(uid, 'uid');
  }
  final CollectionReference<Map<String, dynamic>> _items;
  static const _timeout = Duration(seconds: 20);
  @override
  String allocateId() => _items.doc().id;

  @override
  Stream<List<Deadline>> watch() => _items
      .orderBy('dueAt')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data();
              return Deadline(
                id: doc.id,
                title: data['title'] as String,
                courseId: data['courseId'] as String,
                dueAt: (data['dueAt'] as Timestamp).toDate(),
                completed: data['completed'] as bool,
              );
            })
            .toList(growable: false),
      );

  Map<String, dynamic> _data(Deadline item) => {
    'title': item.title.trim(),
    'courseId': item.courseId,
    'dueAt': Timestamp.fromDate(item.dueAt),
    'completed': item.completed,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  @override
  Future<String> create(Deadline item) async {
    final doc = _items.doc(item.id.isEmpty ? allocateId() : item.id);
    await _items.firestore.runTransaction(
      (transaction) async {
        // Retry the same draft ID after an ambiguous timeout without a second record.
        if ((await transaction.get(doc)).exists) {
          // A retry can include corrections made while the prior result was unknown.
          transaction.update(doc, _data(item));
        } else {
          transaction.set(doc, {
            ..._data(item),
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      },
      timeout: _timeout,
      maxAttempts: 3,
    );
    return doc.id;
  }

  @override
  Future<void> update(Deadline item) {
    if (item.id.isEmpty) throw ArgumentError('Deadline ID required');
    final doc = _items.doc(item.id);
    return _items.firestore.runTransaction(
      (transaction) async {
        if (!(await transaction.get(doc)).exists) {
          throw StateError('Deadline no longer exists');
        }
        transaction.update(doc, _data(item));
      },
      timeout: _timeout,
      maxAttempts: 3,
    );
  }

  @override
  Future<void> delete(String id) {
    if (id.isEmpty) throw ArgumentError('Deadline ID required');
    final doc = _items.doc(id);
    return _items.firestore.runTransaction(
      (transaction) async {
        await transaction.get(doc);
        transaction.delete(doc);
      },
      timeout: _timeout,
      maxAttempts: 3,
    );
  }
}
