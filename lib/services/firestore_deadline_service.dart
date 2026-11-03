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
    final doc = _items.doc();
    await doc.set({..._data(item), 'createdAt': FieldValue.serverTimestamp()});
    return doc.id;
  }

  @override
  Future<void> update(Deadline item) {
    if (item.id.isEmpty) throw ArgumentError('Deadline ID required');
    return _items.doc(item.id).update(_data(item));
  }

  @override
  Future<void> delete(String id) {
    if (id.isEmpty) throw ArgumentError('Deadline ID required');
    return _items.doc(id).delete();
  }
}
