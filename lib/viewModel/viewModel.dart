import 'package:arcore/model/user-model.dart';
import 'package:arcore/repository/repository.dart';
import 'package:flutter/material.dart';
import '../locator.dart';
import '../service/auth-base.dart';

enum ViewState { idle, busy }

class ViewModel extends ChangeNotifier implements FireBaseBase {
  ViewState _state = ViewState.idle;
  final Repository repository = getIt<Repository>();
  UserModel? _user;
  UserModel? get user => _user;
  ViewModel() {
    currentUser();
  }

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    debugPrint('viewstate tetiklendi');
    notifyListeners();
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      state = ViewState.busy;
      _user = await repository.currentUser();
      return user!;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserModel> createWithUserEmailAndPass(
      String email, String pass) async {
    try {
      await repository.createWithUserEmailAndPass(email, pass);
      return _user!;
    } finally {}
  }

  @override
  Future<UserModel> singInWithEmailAndPass(String email, String pass) async {
    try {
      state = ViewState.busy;
      _user = await repository.singInWithEmailAndPass(email, pass);
      notifyListeners();

      return _user!;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserModel> singInWithGoogle() {
    // TODO: implement singInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<bool> singOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }
}
