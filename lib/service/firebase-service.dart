import 'package:arcore/model/user-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth-base.dart';

class FireBaseService implements FireBaseBase {
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Future<UserModel> createWithUserEmailAndPass(
      String email, String pass) async {
    UserCredential credential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass);
    return _userModelFromFirebase(credential.user);
  }

  @override
  Future<UserModel> currentUser() async {
    return _userModelFromFirebase(user);
  }

  @override
  Future<UserModel> singInWithEmailAndPass(String email, String pass) async {
    UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: pass);
    return _userModelFromFirebase(credential.user);
  }

  @override
  Future<UserModel> singInWithGoogle() async{
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
               final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,    
      );
         UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return _userModelFromFirebase(userCredential.user);
  }

  @override
  Future<bool> singOut() async {
    await firebaseAuth.signOut();
    return true;
  }

  UserModel _userModelFromFirebase(User? user) {
    if (user == null) {
      return UserModel(userID: null, email: null);
    }
    return UserModel(userID: user.uid, email: user.email);
  }
}
