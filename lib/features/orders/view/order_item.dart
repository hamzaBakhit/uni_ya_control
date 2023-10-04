import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/orders/logic/orders_bloc.dart';
import 'package:uni_ya_control/features/orders/model/order.dart';
import 'package:uni_ya_control/services/connection.dart';

import '../../../constants/texts.dart';
import '../../../ui/widgets/delete_alert.dart';
import 'older_details.dart';
extension E on String {
  String lastChars(int n) => substring(length - n);
}
class OrderItem extends StatelessWidget {
  OrderItem({required this.order, Key? key}) : super(key: key);
  Order order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Order.showDate(order.orderDate),
          style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              decoration: TextDecoration.underline),
        ),
        Dismissible(
          key: Key(order.id),
          confirmDismiss: (direction) async {
            if (!await checkConnection(context)) {
              return false;
            }
            if (direction == DismissDirection.startToEnd) {
              return await showDialog(
                  context: context,
                  builder: (context) => DeleteAlert(
                        title: TextKeys.areYouSure.tr(),
                        actionTitle: TextKeys.complete.tr(),
                        description: TextKeys.completeDialogDescription.tr(),
                        actionColor: Colors.greenAccent,
                      ));
            } else {
              return await showDialog(
                  context: context,
                  builder: (context) => DeleteAlert(
                        title: TextKeys.areYouSure.tr(),
                        actionTitle: TextKeys.cancel.tr(),
                        description: TextKeys.cancelDialogDescription.tr(),
                        actionColor: Colors.redAccent,
                      ));
            }
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              order.setState(OrderState.completed);
              context.read<OrdersBloc>().add(ChangeOrder(order));
            } else {
              order.setState(OrderState.canceled);
              context.read<OrdersBloc>().add(ChangeOrder(order));
            }
          },
          direction: (order.state == OrderState.finished ||
                  order.state == OrderState.unfinished)
              ? DismissDirection.horizontal
              : DismissDirection.none,
          background: Container(
            color: Colors.greenAccent.withOpacity(0.7),
            alignment: Alignment.center,
            child: Text(
              TextKeys.complete.tr(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.redAccent.withOpacity(0.7),
            alignment: Alignment.center,
            child: Text(
              TextKeys.cancel.tr(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          child: Container(
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ControlOrderDetails(order: order)));
                    },
                    leading: (order.state == OrderState.unfinished)
                        ? IconButton(
                            onPressed: () async {
                              if (await checkConnection(context)) {
                                order.setState(OrderState.finished);
                                context
                                    .read<OrdersBloc>()
                                    .add(ChangeOrder(order));
                              }
                            },
                            icon: Icon(Icons.circle_outlined),
                          )
                        : (order.state == OrderState.finished)
                            ? IconButton(
                                onPressed: () async {
                                  if (await checkConnection(context)) {
                                    order.setState(OrderState.unfinished);
                                    context
                                        .read<OrdersBloc>()
                                        .add(ChangeOrder(order));
                                  }
                                },
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              )
                            : null,
                    title: Text(order.userName),
                    trailing: Text('${order.totalPrice.toStringAsFixed(2)} \$'),
                    subtitle: Text('Id: ${order.id.lastChars(2)}'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
