import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/constants/texts.dart';
import 'package:uni_ya_control/features/analytics/logic/analytics_bloc.dart';
import 'package:uni_ya_control/features/analytics/view/additions_analytic.dart';
import 'package:uni_ya_control/features/analytics/view/meals_analytic.dart';
import 'package:uni_ya_control/features/analytics/view/payment_analytic.dart';

import 'package:uni_ya_control/features/settings/logic/settings_bloc.dart';
import 'package:uni_ya_control/services/connection.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';
import 'package:uni_ya_control/ui/widgets/empty.dart';

import 'time_analytic.dart';

class MainAnalyticsScreen extends StatefulWidget {
  const MainAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<MainAnalyticsScreen> createState() => _MainAnalyticsScreenState();
}

class _MainAnalyticsScreenState extends State<MainAnalyticsScreen> {
  DateTimeRange dateTimeRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 1)), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextKeys.history.tr()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Theme(
                data: context.read<SettingsBloc>().state.isLight
                    ? ThemeData.light()
                    : ThemeData.dark(),
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (!await checkConnection(context)) {
                        return;
                      }
                      var result = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                        initialDateRange: dateTimeRange,
                      );
                      if (result != null) {
                        context.read<AnalyticsBloc>().add(
                            GetOrders(start: result.start, end: result.end));
                      }
                    },
                    child: Text(TextKeys.selectRange.tr()),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: context.watch<AnalyticsBloc>().orders.isEmpty
                  ? const Center(
                      child: EmptyScreen(),
                    )
                  : ListView(
                      children: [
                        AnalyticItem(
                            title: 'Money Analytic',
                            icon: Icons.payments_outlined,
                            function: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentAnalyticScreen()))),
                        AnalyticItem(
                            title: 'Time Analytic',
                            icon: Icons.access_time_filled_rounded,
                            function: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TimeAnalyticScreen()))),
                        AnalyticItem(
                          icon: Icons.fastfood_rounded,
                            title: 'Meals Analytic',
                            function: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealsAnalytic()))),
                        AnalyticItem(
                          icon: Icons.add,
                            title: 'Additions Analytic',
                            function: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdditionsAnalytic()))),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticItem extends StatelessWidget {
  AnalyticItem(
      {required this.title,
      this.description = '',
      required this.function,
      required this.icon,
      Key? key})
      : super(key: key);
  String title, description;
  IconData icon;
  Function function;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () => function(),
        title: Text(title),
        leading: Icon(icon),
      ),
    );
  }
}
