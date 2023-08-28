import 'package:arcore/screen/homePage-screen.dart';
import 'package:arcore/screen/login-screen.dart';
import 'package:arcore/viewModel/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ViewModel>(context, listen: false);
    if (provider.state == ViewState.idle) {
      if (provider.user != null) {
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
}
