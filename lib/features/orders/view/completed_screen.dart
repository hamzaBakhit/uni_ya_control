import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/texts.dart';
import '../../../ui/widgets/empty.dart';
import '../../my_drawer/my_drawer_cubit.dart';
import '../model/order.dart';
import 'order_item.dart';

class CompletedScreen extends StatefulWidget {
   CompletedScreen(this.orders,{Key? key}) : super(key: key);
List<Order>orders;

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TextKeys.completedOrders.tr()),        backgroundColor: Colors.transparent,
        centerTitle: true,leading: IconButton(
        onPressed: () => context.read<MyDrawerCubit>().toggle(),
        icon: Icon(Icons.menu, color: Colors.black,),
      ),),
      backgroundColor: Colors.transparent,
        body: widget.orders.isEmpty?EmptyScreen(): ListView(
          children: widget.orders.map((e) => OrderItem(order: e)).toList(),
        )

    );
  }
}
