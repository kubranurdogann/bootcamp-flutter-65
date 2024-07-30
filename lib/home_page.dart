import 'package:firebase_login_app/chat_page.dart';
import 'package:firebase_login_app/dictionary_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String kullanici;

  const HomePage({super.key, required this.kullanici});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width: 200, child:ElevatedButton(onPressed: (){Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DictionaryPage()),
                              );}, child: const Text("Dictionary"))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width: 200, child:ElevatedButton(onPressed: (){Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatPage()),
                              );}, child: const Text("Chat with AI"))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width: 200, child:ElevatedButton(onPressed: (){}, child: const Text("Test"))),
          ),
        
        ],),
      ),
    );
  }
}
