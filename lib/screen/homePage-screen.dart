import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:arcore/model/user-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../model/item-model.dart';
import '../viewModel/viewModel.dart';

// resimleri hive kayıt ederken sorun oluyore resimleri utily8 cinsine cevirrip veritabanına eklemek ve ordan alırken to yapıp göstermek gerekiyor
class HomePage extends StatefulWidget {
  UserModel user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    saveHiveDB();
    debugPrint('init çalıştı');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add))
          ],
          leading: IconButton(
            onPressed: () async {
              await _singOut(context);
            },
            icon: const Icon(
              CupertinoIcons.power,
            ),
          ),
          title: const Center(child: Text('ARDeco Studio')),
        ),
        body: ListView.builder(
          itemCount: 120,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('deenme'),
              ),
            );
          },
        ));
  }

  Future<void> _singOut(BuildContext context) async {
    final provider = Provider.of<ViewModel>(context, listen: false);
    if (await provider.singOut()) {
      debugPrint('ÇIKIŞ İŞLEMİ BAŞARILIR::::::');
    }
  }

  Future<void> reedHiveDB() async {
    await Hive.openBox<ItemModel>('Item');
    debugPrint('*************************************');
    debugPrint(Hive.box<ItemModel>('Item').length.toString());
  }
}

Future<void> saveHiveDB() async {
  debugPrint('LANDİNG PAGE HİVE ÇALIŞTI');
  await Hive.openBox<ItemModel>('Item');
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
  var box = Hive.box<ItemModel>('Item');
  await box.clear();
  itemList.forEach((element) {
    box.add(element);
  });
}

Future<Uint8List> loadAssetImageAsUint8List(String assetPath) async {
  final ByteData data = await rootBundle.load(assetPath);
  debugPrint(data.buffer.asUint8List().toString());
  return data.buffer.asUint8List();
}
