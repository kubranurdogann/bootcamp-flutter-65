import 'package:firebase_login_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_login_app/login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, password;

  final formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Kaydol",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                        
                      )),
                ),
                SizedBox(height: 25),
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
                SizedBox(height: 10),
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
                Container(
                  width: 400,
                  height: 40,
                  child: ElevatedButton(
                        onPressed: () {
                          SignUp();
                        },
                        child: Text("Kaydol"),
                      ),
                ),
                SizedBox25(),
                SizedBox25(),
                SizedBox25(),
                Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 400,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            }, child: Text("Giriş yap")),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  
  }

  Future<void> SignUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String? result = await AuthService().signUp(email, password);
      if (result == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt başarılı! Giriş yapabilirsiniz.")),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$result")),
        );
        formKey.currentState!.reset();
      }
    }
  }

}
