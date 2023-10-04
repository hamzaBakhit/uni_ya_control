import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/texts.dart';
import '../../../ui/widgets/empty.dart';
import '../../my_drawer/my_drawer_cubit.dart';
import '../logic/orders_bloc.dart';
import '../model/order.dart';
import 'order_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fb;

class FinishedScreen extends StatefulWidget {
  FinishedScreen(this.orders, {Key? key}) : super(key: key);
  List<Order> orders;

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TextKeys.finishedOrders.tr()),
          centerTitle: true,     
             backgroundColor: Colors.transparent,

          leading: IconButton(
            onPressed: () => context.read<MyDrawerCubit>().toggle(),
            icon: Icon(Icons.menu, color: Colors.black,),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: widget.orders.isEmpty?EmptyScreen(): ListView(
          children: widget.orders.map((e) => OrderItem(order: e)).toList(),
        ));
  }
}
