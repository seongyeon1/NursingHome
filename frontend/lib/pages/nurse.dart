import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NursePage extends StatefulWidget {
  @override
  _PatientSchedulePageState createState() => _PatientSchedulePageState();
}

class _PatientSchedulePageState extends State<NursePage> {
  final PageController _pageController = PageController();

  final List<String> roomImages = [
    'assets/images/room1.png',
    'assets/images/room2.png',
    'assets/images/room3.png',
    'assets/images/room4.png',
    'assets/images/room5.png',
    'assets/images/room6.png',
    'assets/images/room7.png',
    'assets/images/room8.png',
    'assets/images/room9.png',
  ];

  final activities = {
    '00:00 - 00:30': {'patient': '취침', 'staff': '취침상태 관찰, 생활실 라운딩'},
    '00:30 - 01:00': {'patient': '취침', 'staff': '취침상태 관찰'},
    '01:00 - 01:30': {'patient': '취침', 'staff': '취침상태 관찰'},
    '01:30 - 02:00': {'patient': '취침', 'staff': '취침상태 관찰'},
    '02:00 - 02:30': {'patient': '취침', 'staff': '취침상태 관찰'},
    '02:30 - 03:00': {'patient': '취침', 'staff': '취침상태 관찰'},
    '03:00 - 03:30': {'patient': '취침', 'staff': '취침상태 관찰'},
    '03:30 - 04:00': {'patient': '취침', 'staff': '취침상태 관찰'},
    '04:00 - 04:30': {'patient': '취침', 'staff': '세탁물 정리, 기저귀 케어'},
    '04:30 - 05:00': {'patient': '취침', 'staff': '세탁물 정리, 기저귀 케어'},
    '05:00 - 05:30': {'patient': '기상', 'staff': '기저귀케어, 체위변경, 위생관리'},
    '05:30 - 06:00': {'patient': '준비운동', 'staff': '준비운동 도와주기'},
    '06:00 - 06:30': {'patient': '아침식사 준비', 'staff': '아침식사 준비'},
    '06:30 - 07:00': {'patient': '아침식사', 'staff': '아침식사 도움'},
    '07:00 - 07:30': {'patient': '식후 정리', 'staff': '식후 정리 및 위생관리'},
    '07:30 - 08:00': {'patient': '휴식', 'staff': '청소 및 정리'},
    '08:00 - 08:30': {'patient': '자유시간', 'staff': '간호 기록 정리'},
    '08:30 - 09:00': {'patient': '활동 참여', 'staff': '활동 지원'},
    '09:00 - 09:30': {'patient': '아침 체조', 'staff': '아침 체조 지원'},
    '09:30 - 10:00': {'patient': '휴식', 'staff': '청소 및 건강 체크'},
    '10:00 - 10:30': {'patient': '물리치료', 'staff': '물리치료 지원'},
    '10:30 - 11:00': {'patient': '자유시간', 'staff': '기록 및 정리'},
    '11:00 - 11:30': {'patient': '오전 간식', 'staff': '오전 간식 준비 및 제공'},
    '11:30 - 12:00': {'patient': '점심 준비', 'staff': '점심 준비'},
    '12:00 - 12:30': {'patient': '점심식사', 'staff': '점심식사 도움'},
    '12:30 - 13:00': {'patient': '식후 휴식', 'staff': '식후 정리 및 휴식 지원'},
    '13:00 - 13:30': {'patient': '개인활동', 'staff': '개인활동 지원'},
    '13:30 - 14:00': {'patient': '휴식', 'staff': '휴식 지원 및 청소'},
    '14:00 - 14:30': {'patient': '오후 활동 준비', 'staff': '활동 준비'},
    '14:30 - 15:00': {'patient': '오후 활동', 'staff': '오후 활동 지원'},
    '15:00 - 15:30': {'patient': '휴식', 'staff': '간호 기록 정리'},
    '15:30 - 16:00': {'patient': '오후 간식', 'staff': '오후 간식 준비 및 제공'},
    '16:00 - 16:30': {'patient': '자유시간', 'staff': '정리 및 휴식 지원'},
    '16:30 - 17:00': {'patient': '저녁식사 준비', 'staff': '저녁식사 준비'},
    '17:00 - 18:00': {'patient': '저녁식사', 'staff': '저녁식사 도움'},
    '18:00 - 19:00': {'patient': '휴식', 'staff': '휴식 지원 및 개인위생 관리'},
    '19:00 - 19:30': {'patient': '개인활동 및 취침 준비', 'staff': '취침 준비 지원'},
    '19:30 - 20:00': {'patient': '휴식', 'staff': '기록 및 정리'},
    '20:00 - 20:30': {'patient': '휴식', 'staff': '기록 및 정리'},
    '20:30 - 21:00': {'patient': '휴식', 'staff': '기록 및 정리'},
    '21:00 - 21:30': {'patient': '취침', 'staff': '취침 지원'},
    '21:30 - 22:00': {'patient': '취침', 'staff': '기록 및 정리'},
    '22:00 - 22:30': {'patient': '취침', 'staff': '라운딩'},
    '22:30 - 23:00': {'patient': '취침', 'staff': '라운딩'},
    '23:00 - 23:30': {'patient': '취침', 'staff': '체위변경, 기저귀 교체'},
    '23:30 - 00:00': {'patient': '취침', 'staff': '체위변경, 기저귀 교체'},
  };


  final meals = {
    '아침': {'menu': '흰밥, 잡곡밥, 콩나물국, 해물볶음우동, 미역줄기볶음, 도라지오이초무침, 배추김치/백김치', 'calories': 612, 'image': 'assets/images/breakfast.jpeg'},
    '점심': {'menu': '흰밥, 잡곡밥, 소고기무국, 동태강정,브로컬리두부기장무침, 연근조림, 배추김치/백김치\n혈액투석식 간식 : 새우꼬치구이', 'calories': 623, 'image': 'assets/images/lunch.jpeg'},
    '저녁': {'menu': '흰밥, 잡곡밥, 우묵국, 단호박카레, 고추장떡, 참나물샐러드, 배추김치/백김치', 'calories': 614, 'image': 'assets/images/dinner.jpeg'},
  };

  String getCurrentMeal() {
    final now = TimeOfDay.now();
    if (now.hour < 9) return '아침';
    if (now.hour < 14) return '점심';
    return '저녁';
  }

  Map<String, String> getCurrentActivity() {
    final now = TimeOfDay.now();
    String formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    for (String key in activities.keys) {
      if (_isCurrentTimeInRange(formattedTime, key)) {
        return activities[key]!;
      }
    }
    return {'patient': '현재 활동 없음', 'staff': '현재 활동 없음'};
  }

  bool _isCurrentTimeInRange(String currentTime, String range) {
    List<String> parts = range.split('-');
    String start = parts[0].trim();
    String end = parts[1].trim();
    return currentTime.compareTo(start) >= 0 && currentTime.compareTo(end) <= 0;
  }

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '전체 환자와 의료진의 일과표',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: activities.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // 항목 간 간격 추가
                  child: ListTile(
                    title: Text(
                      '${entry.key}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '- 환자: ${entry.value['patient']}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent, // 환자 정보 색상 변경
                          ),
                        ),
                        Text(
                          '- 의료진: ${entry.value['staff']}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green, // 의료진 정보 색상 변경
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('하루 식단'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: meals.entries.map((entry) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${entry.key} 식단', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('칼로리: ${entry.value['calories']} kcal'),
                          Text('메뉴: ${entry.value['menu']}'),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => _showImageDialog(context, entry.value['image'] as String),
                        child: Image.asset(
                          entry.value['image'] as String,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
  Widget buildCardContainer({required Widget child}) {
    // This function ensures consistent styling for all containers
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Map<String, String> currentActivity = getCurrentActivity();
    String currentMeal = getCurrentMeal();
    Map<String, dynamic>? mealDetails = meals[currentMeal];

    return Scaffold(
      appBar: AppBar(
        title: Text('환자와 의료진의 현재 일과'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _showScheduleDialog(context),
                child: buildCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('상세한 일과표 보러가기        >', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('현재 시간: ${TimeOfDay.now().format(context)}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('환자: ${currentActivity['patient']}', style: TextStyle(fontSize: 16)),
                      Text('의료진: ${currentActivity['staff']}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '환자 생활 사진',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 400,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: roomImages.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            roomImages[index],
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: roomImages.length,
                        effect: WormEffect(
                          dotWidth: 8.0,
                          dotHeight: 8.0,
                          spacing: 16.0,
                          dotColor: Colors.grey,
                          activeDotColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              if (mealDetails != null) ...[
                GestureDetector(
                  onTap: () => _showMealDialog(context),
                  child: buildCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$currentMeal 식단', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('칼로리: ${mealDetails['calories']} kcal', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        Text('메뉴: ${mealDetails['menu']}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        if (mealDetails['image'] != null)
                          GestureDetector(
                            onTap: () => _showImageDialog(context, mealDetails['image'] as String),
                            child: Image.asset(
                              mealDetails['image'] as String,
                              height: 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(height: 16),
                        Text('오늘 하루 식단 보러가기  > ', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NursePage(),
  ));
}