import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_app/home_page.dart';
import 'package:firebase_login_app/services/auth_service.dart';
import 'package:firebase_login_app/sign_up.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;

  final formKey = GlobalKey<FormState>();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox25(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Hoşgeldiniz",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                        
                      )),
                ),
                SizedBox25(),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen e-posta adresinizi giriniz';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: "What's your email?",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 8.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox10(),
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifre giriniz';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: "What's your password?",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 8.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox25(),
                Center(
                  child: Container(
                    width: 400,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        signIn();
                      },
                      child: Text("Giriş Yap"),
                    ),
                  ),
                ),
                SizedBox25(),
                SizedBox25(),
                SizedBox25(),

                Center(
                  child:Column(
                    children: [
                      Container(
                        width: 400,
                        height: 40,
                        child: ElevatedButton(onPressed: () {
                          Navigator.push( context, MaterialPageRoute( builder: (context) => const SignUp()), );
                        }, child: Text("Kaydol")),
                      ),
                      SizedBox10(),
                      Container(
                        width: 400,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                          final result = await AuthService().signInAnonymous;
                          if(result != "null"){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(kullanici:"Misafir"),));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Hata ile karılaşıldı!")),
                          );
                          }
                          },
                          child: Text("Misafir Girişi")),
                      ),
                    ],
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }


  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String? result = await AuthService().signIn(email, password);
      if (result == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Giriş başarılı!")),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(kullanici: email),));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$result")),
        );
        formKey.currentState!.reset();
      }
    }
  }
}

SizedBox25() {
  return SizedBox(height: 25);
}

SizedBox10() {
  return SizedBox(height: 10);
}
