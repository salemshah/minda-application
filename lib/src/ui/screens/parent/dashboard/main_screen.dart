import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatefulWidget {
  MainDashboard({super.key});

  final Color barBackgroundColor = Color(0xFFD4A1DF);
  final Color barColor = Colors.purple;
  final Color touchedBarColor = Colors.purpleAccent;

  @override
  State<StatefulWidget> createState() => MainDashboardState();
}

class MainDashboardState extends State<MainDashboard> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  List<double> data = [5, 2, 1, 20];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.withOpacity(.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Subjects Performance',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bar chart of subject scores',
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 38),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: BarChart(
                            mainBarData(),
                            duration: animDuration,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = true,
    Color? barColor,
    double width = 60,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          borderSide: isTouched
              ? BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.green, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(4, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, data[0], isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, data[1], isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, data[2], isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, data[3], isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.purple,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String subject;
            switch (group.x) {
              case 0:
                subject = 'Mathematics';
                break;
              case 1:
                subject = 'History';
                break;
              case 2:
                subject = 'Language';
                break;
              case 3:
                subject = 'TEST';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$subject\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Math', style: style);
        break;
      case 1:
        text = const Text('Hist', style: style);
        break;
      case 2:
        text = const Text('Lang', style: style);
        break;
      case 3:
        text = const Text('Test', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }

  Widget getTopTitle(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('0/9', style: style);
        break;
      case 1:
        text = const Text('Hist', style: style);
        break;
      case 2:
        text = const Text('Lang', style: style);
        break;
      case 3:
        text = const Text('Test', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }
}
