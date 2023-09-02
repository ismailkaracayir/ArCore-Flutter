import 'package:arcore/model/item-model.dart';
import 'package:arcore/screen/homePage-screen.dart';
import 'package:arcore/screen/login-screen.dart';
import 'package:arcore/viewModel/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ViewModel>(context);
    if (provider.state == ViewState.idle) {
      debugPrint('LANDİNGPAGE STATE GEÇİLDİ');
      if (provider.user!.email != null) {
        debugPrint('LANDİNGPAGE USER GEÇİLDİ');
        saveHiveDB();
        return HomePage(user: provider.user!);
      } else {
        return LoginPage();
      }
    } else {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
  }

  Future<void> saveHiveDB() async {
    debugPrint('LANDİNG PAGE HİVE ÇALIŞTI');
    await Hive.openBox<ItemModel>('Item');
    List<ItemModel> itemList = [];
    itemList.addAll([
      ItemModel(
          itemID: '1',
          img: Image.asset('assets/images/koltuk.jpeg'),
          name: 'koltuk'),
      ItemModel(
          itemID: '2',
          img: Image.asset('assets/images/koltuk2.jpeg'),
          name: 'koltuk2'),
      ItemModel(
          itemID: '3',
          img: Image.asset('assets/images/koltuk3.jpeg'),
          name: 'koltuk3'),
      ItemModel(
          itemID: '4',
          img: Image.asset('assets/images/sandalye.jpeg'),
          name: 'sandalye'),
      ItemModel(
          itemID: '5',
          img: Image.asset('assets/images/sandalye2.webp'),
          name: 'sandalye2')
    ]);
    var box = Hive.box<ItemModel>('Item');
    await box.clear();
    itemList.forEach((element) {
      box.add(element);
    });
    debugPrint(box.toMap().toString());
  }
}
