import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/ai_nurse.dart';
import 'pages/notice.dart';
import 'pages/help.dart';
import 'pages/patient_info_page.dart';
import 'widgets/custom_nav_bar.dart';
import 'global_state.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final PageController _pageController = PageController(initialPage: GlobalState.selectedIndex);
  int _selectedIndex = GlobalState.selectedIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      GlobalState.selectedIndex = index;
    });
    _pageController.jumpToPage(index); // 애니메이션 없이 즉시 페이지 전환
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      // 현재 HomePage인 경우에는 앱을 종료하거나 기본 동작을 유지함
      return true;
    } else {
      // HomePage가 아닌 경우, HomePage로 돌아가기
      setState(() {
        _selectedIndex = 0;
        GlobalState.selectedIndex = 0;
      });
      _pageController.jumpToPage(0); // HomePage로 이동
      return false; // 뒤로가기 동작 중지 (로그인 페이지로 가지 않음)
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // 뒤로가기 버튼 동작 제어
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
              GlobalState.selectedIndex = index;
            });
          },
          physics: NeverScrollableScrollPhysics(), // 스와이프 비활성화
          children: <Widget>[
            AINursePage(), // AI Nurse Page
            GlobalState.isLoggedIn
                ? PatientInfoPage(userInfo: GlobalState.userInfo ?? {})
                : HomePage(onLogin: navigateToPatientInfoPage), // 로그인 상태에 따라 페이지 변경
            NoticePage(), // Notice Page
            HelpPage(), // Help Page
          ],
        ),
        bottomNavigationBar: GlobalState.isLoggedIn
            ? CustomNavBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              )
            : null, // 로그인 후에만 네비게이션 바 표시
      ),
    );
  }

  void navigateToPatientInfoPage(Map<String, dynamic> info) {
    setState(() {
      GlobalState.isLoggedIn = true;
      GlobalState.userInfo = info;
      _selectedIndex = 1;
    });
    _pageController.jumpToPage(1); // 로그인 후 환자 정보 페이지로 전환
  }
}