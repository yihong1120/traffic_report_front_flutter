import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  void _sendMessage() async {
    var response = await http.post(
      Uri.parse('YOUR_DJANGO_SERVER_URL/chat-with-gemini/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, String>{
        'message': _controller.text,
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
        title: Text('Chat with Gemini'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Text(_response),
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter your message',
            ),
          ),
          ElevatedButton(
            onPressed: _sendMessage,
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}