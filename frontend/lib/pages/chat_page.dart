import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global_state.dart';
import 'dart:convert';
import 'dart:math'; // 무작위 선택을 위해 추가
import 'dart:async'; // 타이머를 위해 추가
import 'dart:html';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart'; // TTS 패키지 추가

class ChatPage extends StatefulWidget {
  final int nurseIdx;

  const ChatPage({required this.nurseIdx});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  late stt.SpeechToText _speech; // Speech to Text instance
  late FlutterTts _tts; // TTS 인스턴스 추가
  bool _isListening = false;
  bool _isSpeaking = false; // TTS 진행 여부를 나타내는 변수 추가

  String _recognizedText = '';
  Timer? _stopListeningTimer; // 타이머 추가
  final int _noInputTimeout = 2; // 2초 동안 입력이 없으면 중지

  @override
  void initState() {
    super.initState();
    requestMicrophonePermission();
    _speech = stt.SpeechToText();
    _tts = FlutterTts(); // TTS 인스턴스 초기화

    // TTS 진행 상태에 따라 _isSpeaking 값을 변경
    _tts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    _tts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _tts.setCancelHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> requestMicrophonePermission() async {
    try {
      final stream = await window.navigator.mediaDevices
          ?.getUserMedia({'audio': true});
      // 마이크 권한이 승인된 경우 처리
    } catch (e) {
      // 마이크 권한이 거부된 경우 처리
      print("Microphone permission denied: $e");
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({"role": "human", "content": _controller.text});
      _isLoading = true;
    });

    final url = Uri.parse('http://localhost:8000/n${widget.nurseIdx}');
    // final url = Uri.parse('http://104.198.208.62:5001/n${widget.nurseIdx}');

    final headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
    };

    final body = json.encode({
      "question": _controller.text,
      "patient_id": GlobalState.patientId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          messages.add({"role": "bot", "content": responseBody['response']});
        });

        await _tts.speak(responseBody['response']); // TTS로 입력된 텍스트 읽어줌

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

    setState(() {
      _isLoading = false;
    });

    _controller.clear();
  }
  void _listen() async {
    if (_isSpeaking) {
      _stopSpeaking(); // TTS가 진행 중이면 TTS 중단
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          setState(() {
            _isListening = _speech.isListening;
          });
        },
        onError: (val) {
          setState(() {
            _isListening = false;
          });
          print('onError: $val');
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _recognizedText = val.recognizedWords;
              _controller.text = _recognizedText;
            });
            _resetStopListeningTimer(); // 입력 시 타이머 리셋
          },
          localeId: "ko_KR", // Set the language to Korean
        );
        _resetStopListeningTimer(); // 타이머 시작
      }
    } else {
      _stopListening();
    }
  }

  void _resetStopListeningTimer() {
    _stopListeningTimer?.cancel(); // 기존 타이머 취소
    _stopListeningTimer = Timer(Duration(seconds: _noInputTimeout), () {
      _stopListening(); // 타이머 만료 시 마이크 중지 및 메시지 전송
    });
  }


  void _stopListening() async {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
      if (_controller.text.isNotEmpty) {
        _sendMessage(); // 자동으로 메시지 전송
      }
    }
  }

  void _stopSpeaking() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  @override
  void dispose() {
    _stopListeningTimer?.cancel();
    _speech.stop();
    _tts.stop(); // TTS 중지
    super.dispose();
  }


  Widget _buildMessage(Map<String, String> message) {
    bool isHuman = message['role'] == "human";
    bool isError = message['role'] == "error";
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Align(
        alignment: isHuman ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isError
                ? Colors.redAccent
                : isHuman
                ? Colors.blueAccent
                : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: isHuman ? Radius.circular(16) : Radius.zero,
              bottomRight: isHuman ? Radius.zero : Radius.circular(16),
            ),
          ),
          child: Text(
            message['content']!,
            style: TextStyle(
              color: isHuman ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }


  // 추천 질문을 무작위로 3개 선택하는 메서드
  List<String> _getRandomSuggestions() {
    List<String> suggestions = [
      '아버님은 어떠세요?',
      '많이 아파하지는 않으신가요?',
      '식사는 잘 하세요?',
      '약은 잘 드세요?',
      '거동은 어떠세요?',
      '밤에 잘 주무세요?',
      '말씀은 잘 하세요?',
      '다른데 아프신 데는 없나요?',
      '병원 방문 예약을 잡을 수 있나요?',
    ];

    suggestions.shuffle(Random());
    return suggestions.take(3).toList();
  }

  // 추천 질문 버튼들을 생성하는 메서드
  Widget _buildSuggestedQuestions() {
    List<String> randomSuggestions = _getRandomSuggestions();

    return Container(
      height: 50, // 높이 설정
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: randomSuggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _controller.text = randomSuggestions[index];
                });
                _sendMessage(); // 메시지 자동 전송
              },
              style: ElevatedButton.styleFrom(
                backgroundColor : Colors.lightGreen, // 버튼 배경색 설정
              ),
              child: Text(
                randomSuggestions[index],
                style: TextStyle(fontSize: 16, color: Colors.white), // 글자색을 흰색으로 설정
              ),
            ),
          );
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    String titleText;

    // nurse_idx 값에 따라 제목 설정
    if (widget.nurseIdx == 1) {
      titleText = 'AI 상담사 친절이';
    } else if (widget.nurseIdx == 2) {
      titleText = 'AI 상담사 간단이';
    } else {
      titleText = 'AI 상담사'; // 기본 제목 (필요한 경우)
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(titleText)
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          if (_isListening) // Show real-time transcription
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _recognizedText.isEmpty
                    ? 'Listening...'
                    : 'Recognizing: $_recognizedText',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          _buildSuggestedQuestions(), // 추천 질문 버튼들을 표시하는 위젯 추가
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 1, // Increase the height of the input field
                    decoration: InputDecoration(
                      hintText: '메시지 입력...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 25, // Increase font size
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                // Enlarged Mic Icon with Conditional TTS Stop Functionality
                SizedBox(
                  width: 60,  // Set width and height for the microphone icon
                  height: 60,
                  child: IconButton(
                    iconSize: 40,  // Increase icon size
                    icon: Icon(
                      _isSpeaking
                          ? Icons.stop // TTS가 진행 중이면 정지 아이콘 표시
                          : _isListening
                          ? Icons.mic
                          : Icons.mic_none,
                      color: _isSpeaking
                          ? Colors.red // 정지 버튼은 빨간색
                          : _isListening
                          ? Colors.red
                          : Colors.blueAccent,
                    ),
                    onPressed: _isSpeaking
                        ? _stopSpeaking // TTS가 진행 중이면 TTS 정지
                        : _listen, // 그렇지 않으면 음성 인식 시작/중지
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
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
//                 SizedBox(width: 8),
//                 // Enlarged Mic Icon
//                 SizedBox(
//                   width: 60,  // Set width and height for the microphone icon
//                   height: 60,
//                   child: IconButton(
//                     iconSize: 40,  // Increase icon size
//                     icon: Icon(
//                       _isListening ? Icons.mic : Icons.mic_none,
//                       color: _isListening ? Colors.red : Colors.blueAccent,
//                     ),
//                     onPressed: _listen,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blueAccent),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }