import 'package:flutter/widgets.dart';
import 'package:saf_worker/models/worker.dart';
import '../resources/auth_methods.dart';

class WorkerProvider with ChangeNotifier {
  Worker? _wrk;
  final AuthMethods _authMethods = AuthMethods();

  Worker get getWorker => _wrk!;

  Future<void> refreshUser() async {
    Worker wrk = await _authMethods.getWrkDetails();
    _wrk = wrk;

    notifyListeners();
  }
}
