import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_mate/models/study_session.dart';
import 'package:deadline_mate/services/study_service.dart';
import 'package:deadline_mate/viewmodels/study_viewmodel.dart';

class FakeStudyRepository implements StudyRepository {
  final controller = StreamController<List<StudySession>>.broadcast(sync: true);
  int plans = 0;
  bool fail = false;
  @override
  Stream<List<StudySession>> watch() => controller.stream;
  @override
  Future<void> plan(String title, DateTime plannedAt, int minutes) async {
    plans++;
    if (fail) throw StateError('offline');
  }

  @override
  Future<void> start(String id) async {
    if (fail) throw StateError('wrong state');
  }

  @override
  Future<void> finish(String id) async {
    if (fail) throw StateError('wrong state');
  }
}

void main() {
  test('duration survives reconstruction and clamps clock inversion', () {
    final start = DateTime(2026, 11, 3, 10);
    final session = StudySession(
      id: 's',
      title: 'Flutter',
      plannedAt: start,
      plannedMinutes: 25,
      status: SessionStatus.running,
      startedAt: start,
    );
    expect(
      session.elapsed(start.add(const Duration(minutes: 12))).inMinutes,
      12,
    );
    expect(
      session.elapsed(start.subtract(const Duration(minutes: 1))),
      Duration.zero,
    );
    final completed = StudySession(
      id: 's',
      title: 'Flutter',
      plannedAt: start,
      plannedMinutes: 25,
      status: SessionStatus.completed,
      startedAt: start,
      endedAt: start.add(const Duration(minutes: 20)),
    );
    expect(completed.elapsed(start.add(const Duration(days: 1))).inMinutes, 20);
  });
  test(
    'invalid plans never write and backend transition failure is visible',
    () async {
      final repo = FakeStudyRepository();
      final vm = StudyViewModel(repo);
      expect(await vm.plan('Flutter', DateTime.now(), 4), isFalse);
      expect(await vm.plan('Flutter', DateTime.now(), 181), isFalse);
      expect(repo.plans, 0);
      repo.fail = true;
      expect(await vm.start('session'), isFalse);
      expect(vm.error, isNotNull);
      expect(vm.busy, isFalse);
      repo.fail = false;
      expect(await vm.plan('Flutter', DateTime.now(), 25), isTrue);
      expect(repo.plans, 1);
      vm.dispose();
      await repo.controller.close();
    },
  );
}
