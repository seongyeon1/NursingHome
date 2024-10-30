import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({"role": "human", "content": _controller.text});
    });

    final url = Uri.parse('http://localhost:8000/process-query');

    final headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
    };

    final body = json.encode({
      "question": _controller.text,
      "patient_id": "남A"
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          messages.add({"role": "bot", "content": responseBody['response']});
        });
      } else {
        setState(() {
          messages.add({"role": "error", "content": "Error: ${response.statusCode}"});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "error", "content": "Failed to connect to the server: $e"});
      });
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI 상담사'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(
                    message['content']!,
                    style: TextStyle(
                      color: message['role'] == "bot"
                          ? Colors.blue
                          : message['role'] == "human"
                          ? Colors.black
                          : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '메시지 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}