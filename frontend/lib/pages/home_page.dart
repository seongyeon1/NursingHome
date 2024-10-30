import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'patient_info_page.dart'; // 다음 페이지를 위한 import
import '../global_state.dart';

class HomePage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onLogin;

  HomePage({required this.onLogin});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final List<String> patientIds = ["남A", "남B", "남C", "여A", "여B", "여C"];

  final Map<String, String> realNames = {
    "남A": "김영수",
    "남B": "박정희",
    "남C": "이순남",
    "여A": "최말순",
    "여B": "한정자",
    "여C": "유복자",
  };

  String? _selectedPatientId;

  final Map<String, String> patientPasswords = {
    "남A": "password123",
    "남B": "password456",
    "남C": "password789",
    "여A": "password321",
    "여B": "password654",
    "여C": "password987",
  };

  Future<void> _login() async {
    if (_selectedPatientId == null) {
      _showAlertDialog('환자명 선택', '로그인할 환자명을 선택하세요.');
      return;
    }

    final String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://104.198.208.62:5001/login'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: json.encode({'patient_id': _selectedPatientId}),
      );

      if (response.statusCode == 200) {
        final userInfo = json.decode(response.body);
        GlobalState.userInfo = userInfo;
        GlobalState.isLoggedIn = true; // 로그인 상태 업데이트

        // 로그인 성공 시 콜백 호출
        widget.onLogin(userInfo);
      } else {
        _showAlertDialog('로그인 실패', '사용자명이나 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      _showAlertDialog('오류', '로그인 중 오류가 발생했습니다. 네트워크 상태를 확인하세요.');
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 뒤로 가기 제어
      onWillPop: () async {
        if (GlobalState.isLoggedIn) {
          return true; // 로그인 상태 유지 시 뒤로 가기 허용
        } else {
          return false; // 로그인 상태가 아니면 뒤로 가기 막기
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    'assets/images/logo.png'), // Ensure this path is correct
                SizedBox(height: 20),
                Text(
                  '효도AI',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '환자안심케어 요양병원 AI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Text('실시간 요양병원 환자 정보 손쉽게 확인하세요',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                DropdownButton<String>(
                  hint: Text('사용자명을 선택하세요'),
                  value: _selectedPatientId,
                  items: patientIds.map((String id) {
                    return DropdownMenuItem<String>(
                      value: id,
                      child: Text(realNames[id] ?? id),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPatientId = newValue;
                      GlobalState.patientId = _selectedPatientId;
                      passwordController.text =
                          patientPasswords[newValue] ?? "";
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    labelStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('로그인', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
