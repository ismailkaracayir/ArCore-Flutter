import 'dart:io';
import 'dart:typed_data';

import 'package:arcore/model/user-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../model/item-model.dart';
import '../viewModel/viewModel.dart';
import 'arcore-screen.dart';

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
  late TextEditingController controller;
  File? newItemImg;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    readHiveDB();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await addNewItem();
                },
                icon: const Icon(CupertinoIcons.add))
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
                      leading: GestureDetector(
                        onTap: () {
                          bigImage(itemList[index].img);
                        },
                        child: Image.memory(
                          itemList[index].img,
                          width: 100,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      title: Text(
                        '${itemList[index].name}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ArCorePage(img: itemList[index].img),
                          ));
                        },
                        child: const Icon(
                          CupertinoIcons.videocam_fill,
                          color: Colors.green,
                          size: 40,
                        ),
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
    itemList.clear();
    final box = await Hive.openBox<ItemModel>('Item');
    debugPrint('init çalıştı');
    for (var element in box.values) {
      itemList.add(element);
    }
    itemList = itemList.reversed.toList();
    setState(() {
      isLoading = true;
    });
  }

  Future<void> bigImage(
    Uint8List img,
  ) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Image.memory(
            img,
            width: 300,
            height: 300,
          ),
        );
      },
    );
  }

  Future<void> addNewItem() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Fotoğraf Ekle'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: () async {
                        debugPrint('img çalıştı');
                        await newImgPicker();
                        setState(() {});
                      },
                      child: newItemImg == null
                          ? Image.asset(
                              'assets/images/empty-img.jpeg',
                              width: 200,
                              height: 220,
                            )
                          : Image.file(
                              newItemImg!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 25,
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'İsim',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Vazgeç')),
            TextButton(
                onPressed: () {
                  submitNewItem();
                },
                child: const Text('Ekle')),
          ],
        );
      },
    );
  }

  Future<void> newImgPicker() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var newImg =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  setState(() {
                    newItemImg = (File(newImg!.path));
                  });
                },
                child: const ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Kamera'),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var newImg = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  setState(() {
                    newItemImg = (File(newImg!.path));
                  });
                },
                child: const ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Galeri'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> submitNewItem() async {
    if (newItemImg != null && controller.text.isNotEmpty) {
      await Hive.openBox<ItemModel>('Item');
      var box = Hive.box<ItemModel>('Item');
      ItemModel newItem = ItemModel(
          itemID: '${itemList.length + 1}',
          img: newItemImg!.readAsBytesSync(),
          name: controller.text);
      box.add(newItem);
      controller.text = '';
      newItemImg = null;
      await Fluttertoast.showToast(
          msg: "Ekleme İşlemi Başarılı",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      await readHiveDB();
      Navigator.pop(context);

      // debugPrint('EKLEME BAŞARILI');
    } else {
      Fluttertoast.showToast(
          msg: "Lütfen Resim ve İsim Alanlarını Doldur",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
