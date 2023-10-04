import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uni_ya_control/features/analytics/logic/analytics_bloc.dart';
import '../../orders/model/order.dart';

class _LineChart extends StatelessWidget {
  _LineChart(this.data,this.isCount);

  List<AnalyticData> data;
  bool isCount;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData(context),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  double getMaxValue() {
    double maxCount = 0;
    for (var i in data) {
      if(isCount){if (i.count > maxCount) {
        maxCount = i.count.toDouble();
      }} else{ if (i.price > maxCount) {
        maxCount = i.price.toDouble();
      }}
    }

    return maxCount;
  }

  LineChartData sampleData(context) {
    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData(context),
      lineBarsData: [lineChartBarData],
      minX: 0,
      maxX: data.length.toDouble(),
      maxY: getMaxValue(),
      minY: 0,
    );
  }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if ([
      0,
      (getMaxValue() * 0.2).toInt(),
      (getMaxValue() * 0.4).toInt(),
      (getMaxValue() * 0.6).toInt(),
      (getMaxValue() * 0.8).toInt(),
      (getMaxValue() * 1).toInt()
    ].contains(value.toInt())) {
      text = value.toInt().toString();
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    String text = '';
    if ([
      0,
      (data.length * 0.3).toInt(),
      (data.length * 0.6).toInt(),
      (data.length * 0.9).toInt(),
    ].contains(value.toInt())) {
      text = '${data[value.toInt()].date.day}/${data[value.toInt()].date.month}';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text,style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData borderData(context) => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
      isCurved: true,
      color: const Color(0xff4e4965),
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: List.generate(data.length,
          (index) => FlSpot(index.toDouble(),isCount? data[index].count.toDouble():data[index].price.toDouble())));
}

class LineChartSample extends StatefulWidget {
  LineChartSample(
      {required this.data,
      required this.title,
      required this.isCount,
      super.key});

  List<AnalyticData> data;
  String title;
  bool isCount;

  @override
  State<StatefulWidget> createState() => LineChartSampleState();
}

class LineChartSampleState extends State<LineChartSample> {
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 6),
                      child: _LineChart(widget.data,widget.isCount),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
