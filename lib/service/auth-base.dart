import '../model/user-model.dart';

abstract class FireBaseBase {
  Future<UserModel> currentUser();
  Future<bool> singOut();
  Future<UserModel> singInWithGoogle();
  Future<UserModel> singInWithEmailAndPass(String email, String pass);
  Future<UserModel> createWithUserEmailAndPass(String email, String pass);
  

}