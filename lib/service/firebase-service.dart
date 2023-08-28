import 'package:arcore/model/user-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth-base.dart';

class FireBaseService implements FireBaseBase {
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
  var credential;
  @override
  Future<UserModel> createWithUserEmailAndPass(String email, String pass) {
    // TODO: implement createWithUserEmailAndPass
    throw UnimplementedError();
  }

  @override
  Future<UserModel> currentUser() async {
     return _userModelFromFirebase(user);
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
    UserModel _userModelFromFirebase(User? user) {
    if (user == null) {
      return UserModel(userID: null, email: null);
    }
    return UserModel(userID: user.uid, email: user.email);
  }
}
