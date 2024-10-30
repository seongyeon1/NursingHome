import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따른 아이콘 및 폰트 크기 설정
    double iconSize = MediaQuery.of(context).size.width * 0.07;
    double selectedFontSize = MediaQuery.of(context).size.width * 0.04;
    double unselectedFontSize = MediaQuery.of(context).size.width * 0.03;
    double barHeight = MediaQuery.of(context).size.height * 0.1; // 바 높이 설정

    return Container(
      height: barHeight,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(Icons.home, '홈', 1, iconSize, selectedFontSize, unselectedFontSize),
          _buildNavItem(Icons.medical_services, 'AI 상담사', 0, iconSize, selectedFontSize, unselectedFontSize),
          _buildNavItem(Icons.notifications, '안내사항', 2, iconSize, selectedFontSize, unselectedFontSize),
          _buildNavItem(Icons.help_outline, '문의사항', 3, iconSize, selectedFontSize, unselectedFontSize), // 문의사항 버튼 추가
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, double iconSize, double selectedFontSize, double unselectedFontSize) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: iconSize, color: isSelected ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: isSelected ? selectedFontSize : unselectedFontSize,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}