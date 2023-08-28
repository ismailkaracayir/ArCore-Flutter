import 'package:arcore/repository/repository.dart';
import 'package:arcore/service/firebase-service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => FireBaseService());
  getIt.registerLazySingleton(() => Repository());
}
