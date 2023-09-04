import 'package:arcore/screen/landing-screen.dart';
import 'package:arcore/viewModel/viewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'model/item-model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter('arcore');
      Hive.registerAdapter(ItemModelAdapter());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const LandingPage(),
      ),
    );
  }
}
