import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class PieChartSample extends StatefulWidget {
  PieChartSample({required this.data, required this.title, super.key});

  String title;

  Map<String, double> data;

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<PieChartSample> {
  int touchedIndex = -1;
  List<Color> colors = [
    Colors.green,
    Colors.blueAccent,
    Colors.redAccent,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constrains) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event,
                                          pieTouchResponse) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
                                        });
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 1,
                                    centerSpaceRadius:
                                        constrains.maxHeight * 0.125,
                                    sections: showingSections(
                                        widget.data, constrains.maxHeight),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListView(
                              children: List.generate(
                                widget.data.length,
                                (i) => ListTile(
                                  title: Text(
                                    widget.data.keys.elementAt(i),
                                    style: TextStyle(
                                        fontSize: constrains.maxWidth * 0.035),
                                  ),
                                  subtitle: Text(
                                      'value: ${widget.data.values.elementAt(i).toStringAsFixed(0)}'),
                                  leading: CircleAvatar(
                                      backgroundColor: colors[i],
                                      radius: constrains.maxWidth * 0.03),
                                  minLeadingWidth: 0,
                                  minVerticalPadding: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      Map<String, double> data, double maxHeight) {
    double total = 0;
    for (double i in data.values) {
      total += i;
    }
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? maxHeight * 0.075 : maxHeight * 0.05;
      final radius = isTouched ? maxHeight * 0.3 : maxHeight * 0.25;

      return PieChartSectionData(
        color: colors[i],
        value: data.values.elementAt(i),
        title:
            '${(data.values.elementAt(i) / total * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }
}
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.all(16),
// child: CircleAvatar(
// backgroundColor: colors[i],
// radius: constrains.maxWidth * 0.03),
// ),
// Text(
// widget.data.keys.elementAt(i),
// style: TextStyle(
// fontSize: constrains.maxWidth * 0.04),
// ),
// ],
// ),
