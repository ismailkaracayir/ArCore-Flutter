import 'dart:typed_data';

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
  List<ItemModel> itemList = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    readHiveDB();
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
        body: isLoading == true
            ? ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image.memory(
                        itemList[index].img,
                        width: 100,
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text('${itemList[index].name}'),
                      trailing: const Icon(
                        CupertinoIcons.videocam_fill,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  Future<void> _singOut(BuildContext context) async {
    final provider = Provider.of<ViewModel>(context, listen: false);
    if (await provider.singOut()) {
      debugPrint('ÇIKIŞ İŞLEMİ BAŞARILIR::::::');
    }
  }

  Future<void> readHiveDB() async {
    final box = await Hive.openBox<ItemModel>('Item');
    debugPrint('init çalıştı');
    for (var element in box.values) {
      itemList.add(element);
    }
    setState(() {
      isLoading = true;
    });
  }
}
