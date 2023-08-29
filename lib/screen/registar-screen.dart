import 'package:arcore/model/user-model.dart';
import 'package:arcore/screen/landing-screen.dart';
import 'package:arcore/screen/login-screen.dart';
import 'package:arcore/viewModel/viewModel.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Email doğru  olduğuna emin olun';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Bu alan boş geçilemez ve en az 6 hane olmalıdır';
                    }
                    return null;
                  },
                  controller: passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Şifre',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    await _registerSubmit();
                  },
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerSubmit() async {
    if (widget.formKey.currentState!.validate()) {
      debugPrint('Form geçerli');

      try {
        debugPrint(emailController.text);
        final provider = Provider.of<ViewModel>(context, listen: false);
        await provider.createWithUserEmailAndPass(
            emailController.text, passController.text);
        await CoolAlert.show(
            backgroundColor: Colors.green,
            barrierDismissible: false,
            title: 'Kayıt Olma',
            context: context,
            type: CoolAlertType.success,
            text: ' Başarı ile Kayıt olundu!',
            autoCloseDuration: const Duration(seconds: 2),
            confirmBtnText: ' ',
            confirmBtnColor: Colors.white);
        Navigator.pop(context,emailController.text);
      } catch (e) {
        debugPrint('REGİSTER OLMADA HATA ÇIKTI GELEN HATA   ${e.toString()}');
      }
    }
  }
}
