import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  bool _isFirstMessage = true;
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThr7qrIazsvZwJuw-uZCtLzIjaAyVW_ZrlEQ&s");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [IconButton(onPressed: _sendMediaMessage, icon: const Icon(Icons.image))]),
      currentUser: currentUser, onSend: _sendMessage, messages: messages);
  }

  void _sendMessage(ChatMessage chatMassage) {
    setState(() {
      messages = [chatMassage, ...messages];
    });
    try {
      String question = chatMassage.text;
      if (_isFirstMessage) {
        question = "This chat will be the chat part of the application I am developing. In the next chat, I want you to chat with the user using simple words suitable for A1 level. ${chatMassage.text}";
        _isFirstMessage = false; // İlk mesajdan sonra bayrağı güncelle
      }
  
      List<Uint8List>? images;

      if(chatMassage.medias?.isNotEmpty ?? false){
        images = [File(chatMassage.medias!.first.url).readAsBytesSync()];
      }

      gemini.streamGenerateContent(question,images:images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts
                  ?.fold("", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(() {
              messages = [lastMessage!, ...messages];
          });
          
        } else {
          String response = event.content?.parts
                  ?.fold("", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage massage = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          
          setState(() {
              messages = [massage, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage()async{
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if(file != null){
     ChatMessage chatMessage = ChatMessage(user: currentUser, createdAt: DateTime.now(), text: "Describe this image:", medias: [
      ChatMedia(url: file.path, fileName: "", type: MediaType.image),
     ]);
     _sendMessage(chatMessage);
    }
  }
}
