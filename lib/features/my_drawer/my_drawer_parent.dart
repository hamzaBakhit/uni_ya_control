
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:uni_ya_control/ui/screens/main_food/main_food.dart';
import 'package:uni_ya_control/ui/screens/main_orders/main_orders.dart';

import 'my_drawer_cubit.dart';
import 'my_drawer_screen.dart';

class MyDrawerParent extends StatefulWidget {
  const MyDrawerParent({Key? key}) : super(key: key);


  @override
  State<MyDrawerParent> createState() => _MyDrawerParentState();
}

class _MyDrawerParentState extends State<MyDrawerParent> {
  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ZoomDrawer(
      controller: context.read<MyDrawerCubit>().controller,
      style: DrawerStyle.defaultStyle,
      menuScreen:const MyDrawerScreen(),
      mainScreen:const MainOrders(),
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      menuScreenTapClose: true,
      overlayBlur: 0.75,
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      drawerShadowsBackgroundColor: Colors.grey.shade300,
      slideWidth: MediaQuery.of(context).size.width*.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}
getPermission()async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}