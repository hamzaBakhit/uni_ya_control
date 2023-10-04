import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/orders/view/canceled_screen.dart';
import 'package:uni_ya_control/features/orders/view/completed_screen.dart';
import 'package:uni_ya_control/features/orders/view/unfinished_screen.dart';
import 'package:uni_ya_control/features/orders/view/finished_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'as fb;
import 'package:uni_ya_control/ui/widgets/backgruond.dart';

import '../../../features/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import '../../../features/bottom_navigation_bar/view/bottom_navigation_bar.dart';

import '../../../features/orders/logic/orders_bloc.dart';
import '../../../features/orders/model/order.dart';

class MainOrders extends StatelessWidget {
  const MainOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child:StreamBuilder<fb.QuerySnapshot<Object?>>(
                    stream:OrdersBloc.data,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        print(snapshot.data!.docs);

                        return  [
                          UnfinishedScreen(snapshot.data!.docs.map((e) =>Order.fromMap(order: e) )
                              .where(
                                  (element) => element.state ==OrderState.unfinished).toList()),
                          FinishedScreen((snapshot.data!.docs.map((e) =>Order.fromMap(order: e) ) .where(
                                  (element) => element.state ==OrderState.finished).toList())),
                          CompletedScreen((snapshot.data!.docs.map((e) =>Order.fromMap(order: e) ) .where(
                                  (element) => element.state ==OrderState.completed).toList())),
                          CanceledScreen((snapshot.data!.docs.map((e) =>Order.fromMap(order: e) ) .where(
                                  (element) => element.state ==OrderState.canceled).toList())),

                        ][context.watch<BottomNavBarCubit>().state];

                      } else {
                        return SizedBox();
                      }
                    }),

               ),
            const BottomNavBar(),
          ],
        ),
      ),
    );
  }
}
