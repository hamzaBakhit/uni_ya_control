import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/constants/texts.dart';
import 'package:uni_ya_control/ui/widgets/empty.dart';
import '../../my_drawer/my_drawer_cubit.dart';
import '../model/order.dart';
import 'order_item.dart';

class CanceledScreen extends StatefulWidget {
  CanceledScreen(this.orders, {Key? key}) : super(key: key);
  List<Order> orders;

  @override
  State<CanceledScreen> createState() => _CanceledScreenState();
}

class _CanceledScreenState extends State<CanceledScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TextKeys.canceledOrders.tr()),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.read<MyDrawerCubit>().toggle(),
            icon: Icon(Icons.menu, color: Colors.black,),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: widget.orders.isEmpty
            ? EmptyScreen()
            : ListView(
                children:
                    widget.orders.map((e) => OrderItem(order: e)).toList(),
              ));
  }
}
