import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:minda_application/src/utils/helper.dart';
import 'package:intl/intl.dart';
import '../../../../blocs/parent/parent_auth_bloc.dart';
import '../../../../blocs/parent/parent_auth_event.dart';
import '../../../../blocs/parent/parent_auth_state.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  final Color barBackgroundColor = const Color(0xFFB3AAED);
  final Color barColor = const Color(0xFF6959C3);
  final Color touchedBarColor = const Color(0xFF6959C3);

  @override
  State<StatefulWidget> createState() => MainDashboardState();
}

class MainDashboardState extends State<MainDashboard> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  List<double> data = [4, 5, 6, 5];
  DateTime selectedDate = DateTime.now();

  int selectedIndex = 0;

  // Child info with no progress data now.
  final List<Map<String, dynamic>> children = [
    {
      'id': 1,
      'name': 'Prénom 1',
      'image': 'assets/images/avatar1.png',
    },
    {
      'id': 2,
      'name': 'Prénom 2',
      'image': 'assets/images/avatar1.png',
    },
    {
      'id': 3,
      'name': 'Prénom 3',
      'image': 'assets/images/avatar1.png',
    },
  ];

  // Separate progress list.
  final List<Map<String, dynamic>> progresses = [
    {
      "childId": '1',
      'progress': [4, 5, 6, 5],
      "date": DateTime.now().toString()
    },
    {
      "childId": '1',
      'progress': [3, 8, 2, 3],
      "date": DateTime.now().subtract(Duration(days: 1)).toString()
    },
    {
      "childId": '2',
      'progress': [9, 5, 2, 7],
      "date": DateTime.now().toString()
    },
    {
      "childId": '2',
      'progress': [3, 5, 2, 9],
      "date": DateTime.now().subtract(Duration(days: 1)).toString()
    },
    {
      "childId": '3',
      'progress': [4, 5, 9, 1],
      "date": DateTime.now().toString()
    },
    {
      "childId": '3',
      'progress': [8, 7, 6, 2],
      "date": DateTime.now().subtract(Duration(days: 1)).toString()
    }
  ];

  @override
  void initState() {
    super.initState();
    context.read<ParentAuthBloc>().add(ParentChildGetRequested());
    updateChartData();
  }

  void updateChartData() {
    final child = children[selectedIndex];
    final childId = child['id'].toString();

    final childProgresses =
        progresses.where((entry) => entry['childId'] == childId);

    String formattedSelectedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate);

    final matchingList = childProgresses.where((progressEntry) {
      DateTime progressDate = DateTime.parse(progressEntry['date']);
      return DateFormat('yyyy-MM-dd').format(progressDate) ==
          formattedSelectedDate;
    });

    Map<String, dynamic>? matchingProgress =
        matchingList.isNotEmpty ? matchingList.first : null;

    setState(() {
      if (matchingProgress != null) {
        data = (matchingProgress['progress'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList();
      } else {
        data = [0, 0, 0, 0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      double width = constraint.maxWidth;
      return Scaffold(
        backgroundColor: const Color(0xFF6959C3),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Parent Dashboard",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              // Description text displayed for the user
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Welcome! Select a date and tap a child's avatar to see updated progress.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: HorizontalWeekCalendar(
                  minDate: DateTime(2025, 1, 1),
                  maxDate: DateTime(2027, 1, 1),
                  initialDate: selectedDate,
                  onDateChange: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    updateChartData();
                  },
                  showTopNavbar: false,
                  monthFormat: "MMMM yyyy",
                  showNavigationButtons: true,
                  weekStartFrom: WeekStartFrom.Monday,
                  borderRadius: BorderRadius.circular(15),
                  activeBackgroundColor: Colors.white,
                  activeTextColor: const Color(0xFF6959C3),
                  inactiveBackgroundColor:
                      const Color(0xFF6959C3).withValues(alpha: 0.6),
                  inactiveTextColor: Colors.white70,
                  disabledTextColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF6959C3).withValues(alpha: 0.3),
                  activeNavigatorColor: Colors.white,
                  inactiveNavigatorColor: Colors.white,
                  monthColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Avatar",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Text(
                  "Choisir un enfant pour voire le progression",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // Horizontal child avatars with fixed height.
              SizedBox(
                height: 150,
                child: BlocBuilder<ParentAuthBloc, ParentAuthState>(
                    builder: (context, state) {
                  if (state is! ParentChildGetSuccess) {
                    return Text("Some thing went wrong");
                  }
                  if (state.children.isEmpty) {
                    return const Center(child: Text("No children found."));
                  }
                  final children = state.children;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: List.generate(children.length, (index) {
                        final imageIndex = index + 1;
                        bool isSelected = selectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            updateChartData();
                          },
                          child: Container(
                            width: width * .7,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFF6959C3),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6959C3),
                                    Color(0xFFAFA5FA),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: width * .2,
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Image.asset(
                                          "assets/images/avatar$imageIndex.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                capitalize(
                                                    children[index].firstName),
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.school,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                children[index]
                                                    .schoolLevel
                                                    .toUpperCase(),
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Progression d'enfant",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Text(
                  "Voir le progression d'enfant",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF6959C3),
                              Color(0xFFAFA5FA),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: BarChart(
                                    mainBarData(),
                                    duration: animDuration,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = true,
    Color? barColor,
    double width = 45,
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
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          borderSide: isTouched
              ? const BorderSide(color: Color(0xFF9F94DF))
              : const BorderSide(color: Color(0xFF9F94DF), width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
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
          getTooltipColor: (_) => const Color(0xFF6D5ADF),
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
                fontSize: 12,
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
        topTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true, getTitlesWidget: getTopTitle, reservedSize: 38),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 1,
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
      color: Colors.white,
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
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text("${data[0].toInt()}/10", style: style);
        break;
      case 1:
        text = Text("${data[1].toInt()}/10", style: style);
        break;
      case 2:
        text = Text("${data[2].toInt()}/10", style: style);
        break;
      case 3:
        text = Text("${data[3].toInt()}/10", style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }
}
