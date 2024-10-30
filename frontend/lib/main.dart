import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'pages/home_page.dart';
import 'global_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlobalState.isLoggedIn ? MyAppWithLayout() : HomePage(onLogin: _handleLogin),
    );
  }

  void _handleLogin(Map<String, dynamic> userInfo) {
    GlobalState.userInfo = userInfo;
    GlobalState.isLoggedIn = true;
    runApp(MyAppWithLayout()); // 로그인 후 새로운 레이아웃으로 이동
  }
}

class MyAppWithLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainLayout(),
    );
  }
}