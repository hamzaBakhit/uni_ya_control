import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/addition/model/addition.dart';
import 'package:uni_ya_control/features/analytics/logic/analytics_bloc.dart';
import 'package:uni_ya_control/features/orders/model/order.dart';
import 'package:uni_ya_control/ui/widgets/empty.dart';
import 'package:uni_ya_control/ui/widgets/loading.dart';
import '../../meal/model/meal.dart';
import 'line_chart_sample.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';

class TimeAnalyticScreen extends StatefulWidget {
  TimeAnalyticScreen({this.id = '', this.isMeal = true, Key? key})
      : super(key: key);
  String id;
  bool isMeal;

  @override
  State<TimeAnalyticScreen> createState() => _TimeAnalyticScreenState();
}

class _TimeAnalyticScreenState extends State<TimeAnalyticScreen> {


  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.id.isEmpty?'Orders Time Analytic':widget.isMeal?'Meals Time Analytic':'Additions Time Analytic'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: FutureBuilder<List<AnalyticData>>(
          future: analytic(),
          builder: (context, data) {
            if (data.hasData && data.data!.isNotEmpty) {
              return Center(
                child: ListView(
                  children: [
                    LineChartSample(
                        title: 'Count Analytic',
                        data: data.data!,
                        isCount: true),
                    if(widget.id.isEmpty)
                    LineChartSample(
                        title: 'Money Analytic',
                        data: data.data!,
                        isCount: false),
                    Center(child: Text('Details')),
                    ...data.data!.map((e) => _item(e)).toList(),
                  ],
                ),
              );
            } else if (data.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            } else {
              return EmptyScreen();
            }
          },
        ),
      ),
    );
  }

  Future<List<AnalyticData>> analytic() async {
    List<AnalyticData> data = [];
    return Future(() {
      for (Order order in context.read<AnalyticsBloc>().orders) {
        if (widget.id.isEmpty) {
          var analyticOrder = data.where(
              (element) => getDate(element.date) == getDate(order.orderDate));
          if (analyticOrder.isEmpty) {
            data.add(AnalyticData(
                '', '', 1, order.totalPrice, getDate(order.orderDate), ''));
          } else {
            analyticOrder.first.addOne(order.totalPrice);
          }
        }
        else if (widget.isMeal) {
          for (Meal meal in Order.setMeals(order.meals)) {
            if (meal.id != widget.id) {
              continue;
            }
            var analyticMeal = data.where((element) =>
                (meal.id == element.id) &&
                (getDate(element.date) == getDate(order.orderDate)));
            if (analyticMeal.isEmpty) {
              data.add(AnalyticData(meal.id, meal.title, meal.count,
                  meal.price * meal.count, getDate(order.orderDate), meal.img));
            } else {
              analyticMeal.first.addOne(meal.price, count: meal.count);
            }
          }
        }
        else {
          List<Addition> _additions = [];
          Order.setAdditions(order.additions).forEach((element) {
            _additions.addAll(element.values);
          });
          for (Addition addition in _additions) {
            if (addition.id != widget.id) {
              continue;
            }
            var analyticAddition = data.where((element) =>
                (getDate(element.date) == getDate(order.orderDate)) &&
                (addition.id == element.id));
            if (analyticAddition.isEmpty) {
              data.add(AnalyticData(addition.id, addition.title, addition.count,
                  order.totalPrice*addition.count, getDate(order.orderDate), addition.img));
            } else {
              analyticAddition.first.addOne(addition.price,count: addition.count);
            }
          }
        }
      }
      data.sort((a, b) => a.date.compareTo(b.date));
      return data;
    });
  }
}

class _item extends StatelessWidget {
  _item(this.item, {Key? key}) : super(key: key);
  AnalyticData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.30),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 2, color: Colors.white30)),
            child: ListTile(
              title: Text(Order.showDate(item.date)),
              trailing: Text('Count: ${item.count}'),
              subtitle: Text('Money: ${item.price.toStringAsFixed(2)} \$'),
            ),
          ),
        ),
      ),
    );
  }
}
