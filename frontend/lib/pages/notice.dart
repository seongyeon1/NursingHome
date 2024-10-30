import 'package:flutter/material.dart';
import 'nurse.dart';
import 'doctor.dart';
import 'board.dart';
import 'report_page.dart'; // 월간 환자 상태 보고서 페이지를 위한 새로운 파일
import '../global_state.dart'; // GlobalState를 가져옴

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  Widget build(BuildContext context) {
    final userInfo = GlobalState.userInfo ?? {};

    // 화면 크기에 따른 아이콘 크기와 컨테이너 크기 설정
    double iconSize = MediaQuery.of(context).size.width * 0.15;
    double containerHeight =
        MediaQuery.of(context).size.height * 0.2; // 컨테이너 높이
    double containerWidth = MediaQuery.of(context).size.width * 0.8; // 컨테이너 너비
    double fontSize = MediaQuery.of(context).size.width * 0.05; // 폰트 크기 동적 설정

    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항', style: TextStyle(fontSize: 28)),
      ),
      body: SingleChildScrollView(
        // 스크롤 가능하도록 수정
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildServiceIconsSection(context, iconSize, fontSize),
              SizedBox(height: 20), // 아이콘 섹션과 보고서 버튼 사이의 간격
              _buildReportButton(context, fontSize),
              SizedBox(height: 20), // 버튼과 요약문 사이의 간격
              _buildReportSummary(userInfo), // 요약문 표시
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIconsSection(
      BuildContext context, double iconSize, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildServiceIcon(context, '의사', Icons.local_hospital, Colors.blue, 1,
              iconSize, fontSize),
          _buildServiceIcon(context, '간호사', Icons.healing, Colors.green, 5,
              iconSize, fontSize),
          _buildServiceIcon(context, '행사', Icons.description, Colors.orange, 2,
              iconSize, fontSize),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context, String label, IconData icon,
      Color color, int notificationCount, double iconSize, double fontSize) {
    return GestureDetector(
      onTap: () {
        if (label == '의사') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorPage()),
          );
        } else if (label == '간호사') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NursePage()),
          );
        } else if (label == '행사') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BoardPage()),
          );
        }
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(iconSize * 0.7),
                ),
                child: Icon(
                  icon,
                  size: iconSize * 0.7,
                  color: color,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  top: -iconSize * 0.05,
                  right: -iconSize * 0.05,
                  child: Container(
                    width: iconSize * 0.3, // Badge width
                    height: iconSize * 0.3, // Badge height
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: iconSize *
                              0.2, // Dynamic font size relative to the icon size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 5), // 텍스트와 아이콘 사이의 간격 줄임
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, double fontSize) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple], // 그라데이션 색상 지정
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportPage()), // 보고서 페이지로 이동
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          backgroundColor: Colors.transparent, // ElevatedButton의 배경을 투명하게 설정
          shadowColor: Colors.transparent, // 그림자 색상도 투명하게 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row가 버튼 크기만큼만 차지하도록 설정
          children: [
            Text(
              '월간 환자 상태 보고서',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white, // 텍스트 색상을 흰색으로 설정
              ),
            ),
            SizedBox(width: 10), // 텍스트와 아이콘 사이에 간격 추가
            Icon(
              Icons.arrow_forward_ios, // > 아이콘 사용
              color: Colors.white, // 아이콘 색상을 흰색으로 설정
              size: fontSize, // 아이콘 크기를 텍스트와 동일하게 설정
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportSummary(Map<String, dynamic> userInfo) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 25, color: Colors.black), // 기본 텍스트 스타일
          children: <TextSpan>[
            TextSpan(
              text: '◦ 이름: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
                text:
                '${userInfo['이름'] ?? 'N/A'} (${userInfo['나이'] ?? 'N/A'}세 / ${userInfo['성별'] ?? 'N/A'})\n'),

            TextSpan(
              text: '◦ 입원일: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${userInfo['입원일'] ?? 'N/A'}\n'),

            TextSpan(
              text: '◦ 병실번호: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${userInfo['병실번호'] ?? 'N/A'}호\n'),

            TextSpan(
              text: '◦ 담당의사: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${userInfo['담당의사'] ?? 'N/A'}\n'),

            TextSpan(
              text: '◦ 기간: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${userInfo['기간'] ?? 'N/A'}\n\n'),

            TextSpan(
              text: '◦ 상태요약: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${userInfo['상태요약'] ?? 'N/A'}\n\n'),
          ],
        ),
      ),
    );
  }
}