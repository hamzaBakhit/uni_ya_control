import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/texts.dart';
import '../../../ui/widgets/empty.dart';
import '../../my_drawer/my_drawer_cubit.dart';
import '../logic/orders_bloc.dart';
import '../model/order.dart';
import 'order_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart'as fb;


class UnfinishedScreen extends StatefulWidget {
   UnfinishedScreen(this.orders,{Key? key}) : super(key: key);
List<Order> orders;
  @override
  State<UnfinishedScreen> createState() => _UnfinishedScreenState();
}

class _UnfinishedScreenState extends State<UnfinishedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKeys.unfinishedOrders.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.read<MyDrawerCubit>().toggle(),
          icon: Icon(Icons.menu),
        ),
      ),
      backgroundColor: Colors.transparent,
        body:   widget.orders.isEmpty?EmptyScreen():ListView(
          children: widget.orders
              .map((e) => OrderItem(order: e))
              .toList(),
        )


    );
  }
}
