import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_mate/models/deadline.dart';
import 'package:deadline_mate/services/deadline_repository.dart';
import 'package:deadline_mate/viewmodels/deadlines_viewmodel.dart';

class TestRepository implements DeadlineRepository {
  final changes = StreamController<List<Deadline>>.broadcast(sync: true);
  int creates = 0;
  bool fail = false;
  Completer<void>? gate;
  @override
  Stream<List<Deadline>> watch() => changes.stream;
  @override
  Future<String> create(Deadline item) async {
    creates++;
    if (gate != null) await gate!.future;
    if (fail) throw StateError('denied');
    return 'created';
  }

  @override
  Future<void> update(Deadline item) async {}
  @override
  Future<void> delete(String id) async {}
}

void main() {
  final item = Deadline(
    id: '',
    title: 'Nộp LAB 3',
    courseId: 'PRM393',
    dueAt: DateTime(2026, 11, 10),
  );
  test('invalid input never writes, failed writes are not success', () async {
    final repo = TestRepository();
    final vm = DeadlinesViewModel(repo);
    expect(await vm.save(item.copyWith(title: '  ')), isFalse);
    expect(repo.creates, 0);
    repo.fail = true;
    expect(await vm.save(item), isFalse);
    expect(vm.error, isNotNull);
    expect(vm.saving, isFalse);
    vm.dispose();
    await repo.changes.close();
  });
  test('double submit writes once and disposal during save is safe', () async {
    final repo = TestRepository()..gate = Completer<void>();
    final vm = DeadlinesViewModel(repo);
    final first = vm.save(item);
    expect(await vm.save(item), isFalse);
    expect(repo.creates, 1);
    vm.dispose();
    repo.gate!.complete();
    expect(await first, isTrue);
    await repo.changes.close();
  });
  test(
    'realtime data filters completed and pending without losing source',
    () async {
      final repo = TestRepository();
      final vm = DeadlinesViewModel(repo);
      repo.changes.add([item, item.copyWith(completed: true)]);
      expect(vm.loading, isFalse);
      vm.setFilter(DeadlineFilter.pending);
      expect(vm.visible.length, 1);
      vm.setFilter(DeadlineFilter.completed);
      expect(vm.visible.single.completed, isTrue);
      expect(vm.items.length, 2);
      vm.dispose();
      await repo.changes.close();
    },
  );
}
