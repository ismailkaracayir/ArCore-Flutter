import 'package:arcore/model/user-model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  UserModel user;
   HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
