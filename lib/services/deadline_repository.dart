import '../models/deadline.dart';

abstract interface class DeadlineRepository {
  Stream<List<Deadline>> watch();
  Future<String> create(Deadline deadline);
  Future<void> update(Deadline deadline);
  Future<void> delete(String id);
}
