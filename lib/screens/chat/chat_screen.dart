import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traffic_report_front_flutter/screens/accounts/login.dart';
import 'package:traffic_report_front_flutter/services/auth_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatPage> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 检查登录状态
  }

  void _checkLoginStatus() async {
      bool isLoggedIn = await AuthService.isLoggedIn(context);
      if (!isLoggedIn) {
          final result = await Navigator.push(
                        context,
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginPage(redirectTo: '/chat'),
              ),
          );

          // 如果result为true，表示用户已成功登录
          if (result == true) {
              // 你可以在这里重新加载页面，或者进行其他需要的操作
              setState(() {});
          }
      }
  }

  final TextEditingController _controller = TextEditingController();
  String _response = '';

  Future<void> _sendMessage(BuildContext context) async {
    var response = await http.post(
      Uri.parse('127.0.0.1/api/chat-with-gemini/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, String>{
        'message': _controller.text,
        'context': context,
      },
    );
    setState(() {
      _response = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CTraffic Info Consultation'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Text(_response),
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter your message',
            ),
          ),
          ElevatedButton(
            onPressed: _sendMessage,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
