import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'item-model.g.dart';

@HiveType(typeId: 1)
class ItemModel {
  @HiveField(0)
  final String itemID;

  @HiveField(1)
  Uint8List img;

  @HiveField(2)
  String? name;
  @override
  String toString() {
    return '$itemID - $name';
  }

  ItemModel({required this.itemID, required this.img, required this.name});
}
