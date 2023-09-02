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
      _user = await repository.createWithUserEmailAndPass(email, pass);
      return user!;
    } finally {}
  }

  @override
  Future<UserModel> singInWithEmailAndPass(String email, String pass) async {
    try {
      state = ViewState.busy;
      _user = await repository.singInWithEmailAndPass(email, pass);
      return user!;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    try {

      state = ViewState.busy;
      _user = await repository.singInWithGoogle();
      return user!;
      
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      state = ViewState.busy;
      bool temp = await repository.singOut();
      _user = UserModel(userID: null, email: null);
      return temp;
    } finally {
      state = ViewState.idle;
    }
  }
}
