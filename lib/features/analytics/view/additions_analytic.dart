import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/analytics/view/time_analytic.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';

import '../../../ui/widgets/cached_image.dart';
import '../../../ui/widgets/empty.dart';
import '../../../ui/widgets/loading.dart';
import '../../addition/model/addition.dart';
import '../../orders/model/order.dart';
import '../logic/analytics_bloc.dart';

class AdditionsAnalytic extends StatefulWidget {
  const AdditionsAnalytic({Key? key}) : super(key: key);

  @override
  State<AdditionsAnalytic> createState() => _AdditionsAnalyticState();
}

class _AdditionsAnalyticState extends State<AdditionsAnalytic> {
  AnalyticData allData=AnalyticData('', '', 0, 0, DateTime.now(), '');
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Additions Analytic'),
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
                    Center(child: Text('Details')),
                    ...data.data!.map((e) => _item(e,allData)).toList(),
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
    allData=AnalyticData('', '', 0, 0, DateTime.now(), '');
    return Future(() {
      for (Order order in context.read<AnalyticsBloc>().orders) {

          List<Addition> _additions = [];
          Order.setAdditions(order.additions).forEach((element) {
            _additions.addAll(element.values);
          });
          for (Addition addition in _additions) {
            allData.addOne(addition.price, count: addition.count);
            var analyticAddition = data.where((element) =>

                (addition.id == element.id));
            if (analyticAddition.isEmpty) {
              data.add(AnalyticData(addition.id, addition.title, addition.count,
                  order.totalPrice*addition.count, getDate(order.orderDate), addition.img));
            } else {
              analyticAddition.first.addOne(addition.price,count: addition.count);
            }
          }

      }
      data.sort((a, b) => b.count.compareTo(a.count));
      return data;
    });
  }
}
class _item extends StatelessWidget {
  _item(this.item,this.all, {Key? key}) : super(key: key);
  AnalyticData item,all;

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
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TimeAnalyticScreen(isMeal: false,id: item.id))),
              title:Text(item.title) ,
              leading: CircleAvatar(backgroundColor: Colors.transparent,child: CachedImage(item.img)),
              trailing: Text('${(item.count/all.count*100).toStringAsFixed(2)} %'),
              subtitle: Text('Count: ${item.count}'),
            ),
          ),
        ),
      ),
    );
  }
}
