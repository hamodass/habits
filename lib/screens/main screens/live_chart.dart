import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';

class LiveChartWidget extends StatefulWidget {
  HabitModel? habits;
  LiveChartWidget({this.habits});
  @override
  State<StatefulWidget> createState() => LiveChartWidgetState();
}

class LiveChartWidgetState extends State<LiveChartWidget> {
  final List<double> weeklyData = [1, 1, 1, 1, 1, 1, 1];
  int? touchedIndex;

  getDays() {
    widget.habits!.perWeek!.map((e) => print(e.name));
  }

  @override
  void initState() {
    getDays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: const Color(0xff81e5cd),
      ),
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Analysis',
            style: TextStyle(
                color: Color(0xff0f4a3c),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'Weekly Habit Tracking',
            style: TextStyle(
                color: Color(0xff0f4a3c),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BarChart(
                mainBarData(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBar(
    int x,
    double y, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: [
            Colors.yellow,
            Colors.white,
          ],
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [const Color(0xff72d8bf)],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildAllBars() {
    return List.generate(
      widget.habits!.perWeek!.length,
      (index) =>
          _buildBar(index, weeklyData[index], isTouched: index == touchedIndex),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: _buildBarTouchData(),
      titlesData: _buildAxes(),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _buildAllBars(),
    );
  }

  FlTitlesData _buildAxes() {
    return FlTitlesData(
      // Build X axis.
      bottomTitles: SideTitles(
        showTitles: true,
        margin: 16,
        getTitles: (double value) {
          switch (value.toInt()) {
            case 0:
              return 'M';
            case 1:
              return 'T';
            case 2:
              return 'W';
            case 3:
              return 'T';
            case 4:
              return 'F';
            case 5:
              return 'S';
            case 6:
              return 'S';
            default:
              return '';
          }
        },
      ),
      // Build Y axis.
      leftTitles: SideTitles(
        showTitles: false,
        getTitles: (double value) {
          return value.toString();
        },
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String? weekDay;
          switch (group.x.toInt()) {
            case 0:
              weekDay = 'Monday';
              break;
            case 1:
              weekDay = 'Tuesday';
              break;
            case 2:
              weekDay = 'Wednesday';
              break;
            case 3:
              weekDay = 'Thursday';
              break;
            case 4:
              weekDay = 'Friday';
              break;
            case 5:
              weekDay = 'Saturday';
              break;
            case 6:
              weekDay = 'Sunday';
              break;
          }
          return BarTooltipItem(
            weekDay! + '\n' + (rod.y).toString(),
            const TextStyle(color: Colors.yellow),
          );
        },
      ),
      touchCallback: (p0, p1) {
        //   setState(() {
        //     if (barTouchResponse.spot != null &&
        //         barTouchResponse.touchInput is! FlPanEnd &&
        //         barTouchResponse.touchInput is! FlLongPressEnd) {
        //       touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
        //     } else {
        //       touchedIndex = -1;
        //     }
        //   });
      },
      // touchCallback: (barTouchResponse) {

      // },
    );
  }
}
