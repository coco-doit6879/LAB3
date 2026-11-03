import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/course.dart';

abstract interface class CourseRepository {
  Stream<List<Course>> watch();
  Future<void> create(String name, String code);
}

class FirestoreCourseService implements CourseRepository {
  FirestoreCourseService(String uid)
    : _courses = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('courses');
  final CollectionReference<Map<String, dynamic>> _courses;
  @override
  Stream<List<Course>> watch() => _courses
      .orderBy('name')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Course(
                id: doc.id,
                name: doc.data()['name'] as String,
                code: doc.data()['code'] as String,
              ),
            )
            .toList(growable: false),
      );
  @override
  Future<void> create(String name, String code) => _courses.add({
    'name': name.trim(),
    'code': code.trim(),
    'createdAt': FieldValue.serverTimestamp(),
  });
}
