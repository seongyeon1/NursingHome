import 'package:flutter/material.dart';
import 'chat_page.dart';

class AINursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따른 동적 크기 설정
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = screenWidth * 0.2;
    double containerWidth = screenWidth * 0.9;
    double containerPadding = screenWidth * 0.05;
    double fontSizeTitle = screenWidth * 0.07;
    double fontSizeSubtitle = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: Text('상담하기', style: TextStyle(fontSize: fontSizeTitle)),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(containerPadding),
        child: Center(
          child: Container(
            width: containerWidth,
            padding: EdgeInsets.all(containerPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'AI 상담사 선택하기',
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(nurseIdx: 2)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0), // 내부 패딩 추가
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1), // 배경색 설정
                      borderRadius: BorderRadius.circular(16.0), // 모서리 둥글게 설정

                      // border: Border.all(
                      //   color: Colors.blueAccent, // 테두리 색상 설정
                      //   width: 0.0, // 테두리 두께 설정
                      // ),
                    ),
                    child: _buildAIConsultantTile(
                      'AI 상담사 간단이',
                      'assets/images/nurse2.png',
                      '전문적이고 요점만 간단히 환자분의 상황을 알려드립니다.',
                      iconSize,
                      fontSizeSubtitle,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(nurseIdx: 1)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0), // 내부 패딩 추가
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1), // 배경색 설정
                      borderRadius: BorderRadius.circular(16.0), // 모서리 둥글게 설정
                      // border: Border.all(
                      //   color: Colors.greenAccent, // 테두리 색상 설정
                      //   width: 0.0, // 테두리 두께 설정
                      // ),
                    ),
                    child: _buildAIConsultantTile(
                      'AI 상담사 친절이',
                      'assets/images/nurse1.png',
                      '친절하고 자세하게 환자분의 상황을 설명해드리겠습니다.',
                      iconSize,
                      fontSizeSubtitle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIConsultantTile(String title, String imagePath, String subtitle,
      double iconSize, double fontSizeSubtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: iconSize, // 동적 크기 설정
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSizeSubtitle,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Container(
          width: iconSize * 3, // 텍스트의 줄바꿈을 위해 넓이 설정
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSizeSubtitle * 0.8), // 부제목은 조금 작게
          ),
        ),
      ],
    );
  }
}
