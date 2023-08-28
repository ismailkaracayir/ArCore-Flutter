import 'package:arcore/model/user-model.dart';
import 'package:arcore/repository/repository.dart';
import 'package:flutter/material.dart';
import '../locator.dart';
import '../service/auth-base.dart';

enum ViewState { idle, busy }

class ViewModel extends ChangeNotifier implements FireBaseBase {
  final Repository firebaseFirestore = getIt<Repository>();
  UserModel? _user;
  ViewState _state = ViewState.idle;

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
      _user = await firebaseFirestore.currentUser();
      return user!;
    } finally {
         state = ViewState.idle;
    }
  }

  @override
  Future<UserModel> createWithUserEmailAndPass(String email, String pass) {
    // TODO: implement createWithUserEmailAndPass
    throw UnimplementedError();
  }

  @override
  Future<UserModel> singInWithEmailAndPass(String email, String pass) {
    // TODO: implement singInWithEmailAndPass
    throw UnimplementedError();
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
