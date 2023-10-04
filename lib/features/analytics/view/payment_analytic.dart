import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/analytics/logic/analytics_bloc.dart';
import 'pie_chart_sample.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';

class PaymentAnalyticScreen extends StatefulWidget {
  const PaymentAnalyticScreen({Key? key}) : super(key: key);

  @override
  State<PaymentAnalyticScreen> createState() => _PaymentAnalyticScreenState();
}

class _PaymentAnalyticScreenState extends State<PaymentAnalyticScreen> {
  bool isCount = true;
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Money Analytic'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: ListView(

              children: [
                SwitchListTile(
                  title:const Text('Analysis by count / price'),
                    value: isCount,
                    onChanged: (value) => setState(() {
                          isCount = value;
                        })),
                PieChartSample(title:'Payment Method',data: isCount?context.read<AnalyticsBloc>().methodCount:context.read<AnalyticsBloc>().methodMoney,),
                PieChartSample(title:'Place',data: isCount?context.read<AnalyticsBloc>().placeCount:context.read<AnalyticsBloc>().placeMoney,),
              ],
            ),
        ),
        ),
    );
  }
}
