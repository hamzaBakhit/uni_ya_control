
import 'package:flutter/material.dart';
import 'package:uni_ya_control/features/make_order/view/older_details.dart';
import 'package:uni_ya_control/features/analytics/view/main_analytics.dart';
import 'package:uni_ya_control/ui/screens/main_food/main_food.dart';
import 'package:uni_ya_control/ui/screens/making_order/home/home.dart';

import '../features/admin/view/admins_screen/admins_screen.dart';
import '../features/admin/view/log_in_screen/log_in_screen.dart';
import '../features/my_drawer/my_drawer_parent.dart';
import '../features/settings/view/settings_screen.dart';

class Routes{
  final Map<String,WidgetBuilder> routes={
   logIn:(context)=>const LogInScreen(),
   mainFood:(context)=>const MainFood(),
   mainOrders:(context)=>const MyDrawerParent(),
   oldOrders:(context)=>const MainAnalyticsScreen(),
   settings:(context)=>const SettingsScreen(),
   admins:(context)=>const AdminsScreen(),
   makeOrderHome:(context)=>const MakeOrderHome(),
   orderDetails:(context)=>const OrderDetails(),

  };
  static const String initialRoute=logIn;
  static const String logIn='/logIn';
  static const String mainFood='/main_food';
  static const String mainOrders='/main_orders';
  static const String settings='/settings';
  static const String admins='/admins';
  static const String oldOrders='/old_orders';
  static const String makeOrderHome='/make_order_home';
  static const String orderDetails='/order_details';

}