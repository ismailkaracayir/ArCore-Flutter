import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'item-model.g.dart';

@HiveType(typeId: 1)
class ItemModel {
  @HiveField(0)
  final String itemID;

  @HiveField(1)
  Image img;

  @HiveField(2)
  String? name;
  @override
  String toString() {
    return '$itemID - $name';
  }

  ItemModel({required this.itemID, required this.img, required this.name});
}
