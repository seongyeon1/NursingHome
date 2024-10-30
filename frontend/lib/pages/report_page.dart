import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'chart_data.dart';
import '../global_state.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedVitalSign = '혈압';

  @override
  Widget build(BuildContext context) {
    // GlobalState에서 사용자 정보 가져오기
    final userInfo = GlobalState.userInfo;

    if (userInfo == null) {
      // userInfo가 null인 경우에 대한 처리
      return Scaffold(
        appBar: AppBar(
          title: Text('월간 환자 상태 보고서'),
        ),
        body: Center(
          child: Text('사용자 정보를 불러올 수 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('월간 환자 상태 보고서', style: TextStyle(fontSize: 30)), // Increased font size
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 22, color: Colors.black), // 기본 텍스트 스타일
                  children: <TextSpan>[
                    TextSpan(
                      text: '◦ 이름: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                        '${userInfo['이름']} (${userInfo['나이']}세 / ${userInfo['성별']})\n'),

                    TextSpan(
                      text: '◦ 입원일: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${userInfo['입원일']}\n'),

                    TextSpan(
                      text: '◦ 병실번호: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${userInfo['병실번호']}호\n'),

                    TextSpan(
                      text: '◦ 담당의사: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${userInfo['담당의사']}\n'),

                    TextSpan(
                      text: '◦ 기간: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${userInfo['기간']}\n'), // 날짜 고려 ?
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildPatientSummary(),
              const SizedBox(height: 20),
              _buildVitalSignsGraph(),
              const SizedBox(height: 20),
              _buildHospitalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSummary() {
    final userInfo = GlobalState.userInfo;

    if (userInfo == null) {
      // userInfo가 null인 경우에 대한 처리
      return Scaffold(
        appBar: AppBar(
          title: Text('월간 환자 상태 보고서'),
        ),
        body: Center(
          child: Text('사용자 정보를 불러올 수 없습니다.'),
        ),
      );
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          Text(
            '상태 요약',
            style: TextStyle(
              fontSize: 26, // Increased font size
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10), // Added spacing between title and content
          Text(
            '${userInfo['상태요약']}',
            style: TextStyle(fontSize: 20, height: 1.5), // Adjusted font size and line height
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignsGraph() {
    return Container(
      height: 200, // Reduced height
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Reduced vertical padding
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '활력 징후',
            style: TextStyle(
              fontSize: 26, // Increased font size
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildVitalSignButton('혈압'),
              _buildVitalSignButton('맥박'),
              _buildVitalSignButton('호흡'),
              _buildVitalSignButton('체온'),
            ],
          ),
          const SizedBox(height: 5), // Reduced spacing
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: _getVitalSignData(selectedVitalSign),
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignButton(String vitalSign) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedVitalSign = vitalSign;
        });
      },
      child: Text(vitalSign),
      style: ElevatedButton.styleFrom(
        backgroundColor:
        selectedVitalSign == vitalSign ? Colors.blue : Colors.grey,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18),
      ),
    );
  }

  List<ChartData> _getVitalSignData(String vitalSign) {
    switch (vitalSign) {
      case '혈압':
        return [
          ChartData('7/1', 120),
          ChartData('7/5', 125),
          ChartData('7/10', 130),
          ChartData('7/15', 128),
          ChartData('7/20', 122),
          ChartData('7/25', 118),
          ChartData('7/30', 126),
        ];
      case '맥박':
        return [
          ChartData('7/1', 70),
          ChartData('7/5', 72),
          ChartData('7/10', 68),
          ChartData('7/15', 75),
          ChartData('7/20', 70),
          ChartData('7/25', 73),
          ChartData('7/30', 69),
        ];
      case '호흡':
        return [
          ChartData('7/1', 16),
          ChartData('7/5', 17),
          ChartData('7/10', 15),
          ChartData('7/15', 18),
          ChartData('7/20', 16),
          ChartData('7/25', 17),
          ChartData('7/30', 16),
        ];
      case '체온':
        return [
          ChartData('7/1', 36.5),
          ChartData('7/5', 36.6),
          ChartData('7/10', 36.7),
          ChartData('7/15', 36.5),
          ChartData('7/20', 36.8),
          ChartData('7/25', 36.6),
          ChartData('7/30', 36.7),
        ];
      default:
        return [];
    }
  }

  Widget _buildHospitalInfo() {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '병원 정보',
            style: TextStyle(
              fontSize: 26, // Increased font size
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10), // Added spacing between title and content
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 18, height: 1.5, color: Colors.black), // 기본 텍스트 스타일
              children: <TextSpan>[
                TextSpan(
                  text: '◦ 병원 연락처: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '02-2347-1206\n'),

                TextSpan(
                  text: '◦ 병원 이메일: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: 'contact@nursinghospital.com\n'),

                TextSpan(
                  text: '◦ 병원 홈페이지: \n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: 'http://www.nursinghospital.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}