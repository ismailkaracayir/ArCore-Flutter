import 'package:arcore/model/user-model.dart';

import '../locator.dart';
import '../service/auth-base.dart';
import '../service/firebase-service.dart';

class Repository implements FireBaseBase {
  final FireBaseService firebaseFirestore = getIt<FireBaseService>();

  @override
  Future<UserModel> createWithUserEmailAndPass(String email, String pass) {
    // TODO: implement createWithUserEmailAndPass
    throw UnimplementedError();
  }

  @override
  Future<UserModel> currentUser() async {
    return firebaseFirestore.currentUser();
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
