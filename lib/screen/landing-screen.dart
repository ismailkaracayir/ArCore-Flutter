import 'package:arcore/screen/homePage-screen.dart';
import 'package:arcore/screen/login-screen.dart';
import 'package:arcore/viewModel/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

import '../model/item-model.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    saveHiveDB();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ViewModel>(context);
    if (provider.state == ViewState.idle) {
      debugPrint('LANDİNGPAGE STATE GEÇİLDİ');
      if (provider.user!.email != null) {
        debugPrint('LANDİNGPAGE USER GEÇİLDİ');
        return HomePage(
          user: provider.user!,
        );
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
    var box = Hive.box<ItemModel>('Item');
    List<ItemModel> itemList = [];
    itemList.addAll([
      ItemModel(
          itemID: '1',
          img: await loadAssetImageAsUint8List(
              'assets/images/koltuk.jpeg'), //File('assets/images/koltuk.jpeg').readAsBytes(),
          name: 'koltuk'),
      ItemModel(
          itemID: '2',
          img: await loadAssetImageAsUint8List(
              'assets/images/koltuk2.jpeg'), //File('assets/images/koltuk.jpeg').readAsBytes(),
          name: 'koltuk2'),
      ItemModel(
          itemID: '3',
          img: await loadAssetImageAsUint8List(
              'assets/images/koltuk3.jpeg'), //File('assets/images/koltuk.jpeg').readAsBytes(),
          name: 'koltuk3'),
      ItemModel(
          itemID: '4',
          img: await loadAssetImageAsUint8List(
              'assets/images/sandalye.jpeg'), //File('assets/images/koltuk.jpeg').readAsBytes(),
          name: 'sandalye'),
      ItemModel(
          itemID: '5',
          img: await loadAssetImageAsUint8List(
              'assets/images/sandalye2.webp'), //File('assets/images/koltuk.jpeg').readAsBytes(),
          name: 'sandalye2'),
    ]);

    if (box.isEmpty) {
      itemList.forEach((element) {
        box.add(element);
      });
    }
  }

  Future<Uint8List> loadAssetImageAsUint8List(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    debugPrint(data.buffer.asUint8List().toString());
    return data.buffer.asUint8List();
  }
}
