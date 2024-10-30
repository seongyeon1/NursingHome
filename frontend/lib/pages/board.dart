import 'package:flutter/material.dart';

class BoardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EventListPage(); // MaterialApp을 제거하고 직접 EventListPage를 반환
  }
}

class Event {
  final String title;
  final String date;
  final String details;

  Event({required this.title, required this.date, required this.details});
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final List<Event> events = [
    Event(
      title: '효잔치 개최 안내',
      date: '10월 15일 (토) 오후 2시',
      details: '병원 내 어르신들을 위한 특별한 효잔치가 열립니다. 전통 가요제, 민속 놀이, 카네이션 달아드리기 등 다양한 프로그램을 준비했습니다. 어르신들과 함께 즐거운 시간을 보내세요.',
    ),
    Event(
      title: '힐링콘서트 안내',
      date: '9월 5일 (월) 오후 3시',
      details: '환자분들의 마음을 위로하는 힐링콘서트가 열립니다. 편안한 음악과 함께 환자분들의 우울감을 덜어드리고자 합니다. 많은 참여 부탁드립니다.',
    ),
    Event(
      title: '회상요법 워크숍 개최',
      date: '11월 10일 (목) 오전 10시',
      details: '치매와 관련된 기억 회복을 돕는 회상요법 워크숍이 열립니다. 옛 추억을 되새기며 인지력 향상과 심리적 안정을 도모합니다. 보호자분들의 많은 관심 부탁드립니다.',
    ),
    Event(
      title: '야외행사 ‘정월대보름잔치’ 안내',
      date: '2월 8일 (수) 오후 1시',
      details: '환자분들을 위한 야외 정월대보름잔치가 병원 앞마당에서 열립니다. 다양한 전통 놀이와 맛있는 음식을 준비하여 즐거운 시간을 보내실 수 있습니다.',
    ),
    Event(
      title: '미용 봉사 프로그램 안내',
      date: '매주 수요일 오전 9시~12시',
      details: '자원봉사자들과 함께하는 미용 서비스가 제공됩니다. 메이크업, 피부관리, 이·미용 서비스를 통해 환자분들의 자존감을 높이고 활력을 불어넣어 드립니다.',
    ),
    Event(
      title: '문학치료 프로그램 안내',
      date: '매월 첫째 주 화요일 오후 2시',
      details: '문학을 통해 마음의 치유와 심리적 안정을 도모하는 문학치료 프로그램이 진행됩니다. 책을 읽고 이야기 나누며 환자분들의 정서적 안정을 돕습니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('요양원 행사 목록'),
        automaticallyImplyLeading: true, // 뒤로가기 버튼이 활성화되어야 함
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              events[index].title,
              style: TextStyle(
                fontSize: 24, // 큰 글씨로 제목 표시
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              events[index].date,
              style: TextStyle(
                fontSize: 18, // 큰 글씨로 날짜 표시
                color: Colors.grey[600],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios, // > 아이콘 사용
              color: Colors.grey[600], // 아이콘 색상을 날짜와 동일하게 설정
              size: 20, // 아이콘 크기 설정
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      events[index].title,
                      style: TextStyle(
                        fontSize: 24, // 큰 글씨로 제목 표시
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      events[index].details,
                      style: TextStyle(
                        fontSize: 18, // 큰 글씨로 내용 표시
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          '닫기',
                          style: TextStyle(
                            fontSize: 18, // 큰 글씨로 버튼 표시
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}