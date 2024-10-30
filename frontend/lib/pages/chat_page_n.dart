import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 패키지 임포트
import 'dart:convert'; // JSON 처리용 패키지 임포트

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = []; // 메시지 리스트를 Map으로 변경하여 역할 구분
  final TextEditingController _controller = TextEditingController();

  // LangServe API 호출 및 메시지 전송 함수
  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // 사용자 메시지를 리스트에 추가
    setState(() {
      messages.add({"role": "human", "content": _controller.text});
    });

    // LangServe API로 메시지 전송
    // final url = Uri.parse('http://localhost:8000/main/invoke'); // Simulator
    final url = Uri.parse('http://localhost:8000/process-query'); // Simulator for AI backend FastAPI
    // final url = Uri.parse('http://192.168.45.160:8000/main/invoke'); // Connect Phone

    final headers = {
      "Content-Type": "application/json",
      "accept": "application/json"
    };

    final body = json.encode({
      "question": _controller.text,
      "patient_id": "1" // 필요한 경우 이 값을 동적으로 변경할 수 있습니다.
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Raw response: ${response.body}'); // 응답 출력

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        setState(() {
          messages.add({"role": "bot", "content": responseBody['output']});
        });
      } else {
        setState(() {
          messages.add({"role": "error", "content": "Error: ${response.statusCode}"});
        });
      }
    }

    catch (e) {
      setState(() {
        messages.add({"role": "error", "content": "Failed to connect to the server: $e"});
      });
    }

    _controller.clear(); // 입력 필드 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: <Widget>[
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
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Send a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // 버튼 클릭 시 메시지 전송
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}