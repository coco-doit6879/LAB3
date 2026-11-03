import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_mate/models/app_user.dart';
import 'package:deadline_mate/services/auth_service.dart';
import 'package:deadline_mate/viewmodels/auth_viewmodel.dart';

class FakeAuth implements AuthRepository {
  final stream = StreamController<AppUser?>.broadcast(sync: true);
  bool fail = false;
  @override
  Stream<AppUser?> get changes => stream.stream;
  @override
  Future<void> signIn() async {
    if (fail) throw StateError('cancelled');
    stream.add(const AppUser(uid: 'user-a'));
  }

  @override
  Future<void> signOut() async {
    stream.add(null);
  }
}

void main() {
  test(
    'auth cancellation grants no access; success and logout follow auth stream',
    () async {
      final service = FakeAuth();
      final vm = AuthViewModel(service);
      service.stream.add(null);
      service.fail = true;
      await vm.signIn();
      expect(vm.user, isNull);
      expect(vm.error, isNotNull);
      expect(vm.busy, isFalse);
      service.fail = false;
      await vm.signIn();
      expect(vm.user?.uid, 'user-a');
      expect(vm.error, isNull);
      await vm.signOut();
      expect(vm.user, isNull);
      vm.dispose();
      await service.stream.close();
    },
  );
}
