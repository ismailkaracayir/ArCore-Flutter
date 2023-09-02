import 'package:arcore/screen/registar-screen.dart';
import 'package:arcore/viewModel/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();
final formKey = GlobalKey<FormState>();

class _LoginDemoState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                    await loginSubmit();
                  },
                  child: const Text(
                    'Giriş',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton.icon(
                  onPressed: () {
                    _logingoogle();
                  },
                  icon: const Icon(
                    Icons.social_distance,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Google ile Giriş',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () async {
                  emailController.text = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          )) ??
                      '';
                  passController.text = '';
                },
                child: const Text(
                  'Hesabın yok mu? Yeni hesap oluştur.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        final provider = Provider.of<ViewModel>(context, listen: false);
        provider.singInWithEmailAndPass(
            emailController.text, passController.text);
        emailController.text = '';
        passController.text = '';
      } catch (e) {
        debugPrint('LOGİN OLMADA HATA ÇIKTO GELEN HATA ${e.toString()}');
      }
    }
  }

  Future<void> _logingoogle() async {
    try {
      final provider = Provider.of<ViewModel>(context, listen: false);
      await provider.singInWithGoogle();
    } catch (erorr) {
      debugPrint(
          'GOOGLE LOGİN OLMADA HATA ÇIKTO GELEN HATA ${erorr.toString()}');
    }
  }
}
