import 'package:arcore/model/user-model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/viewModel.dart';

class HomePage extends StatefulWidget {
  UserModel user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('ARDeco Studio')),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                await _singOut();
              },
              child: Text('Çıkış')),
          Center(
            child: Text('${widget.user.email}'),
          ),
        ],
      ),
    );
  }

  Future<void> _singOut() async {
    final provider = Provider.of<ViewModel>(context, listen: false);
    if (await provider.singOut()) {
      debugPrint('ÇIKIŞ İŞLEMİ BAŞARILIR::::::');
    }
  }
}
