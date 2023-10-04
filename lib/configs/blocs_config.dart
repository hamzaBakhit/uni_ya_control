import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/analytics/logic/analytics_bloc.dart';
import 'package:uni_ya_control/features/make_order/make_order_bloc.dart';
import 'package:uni_ya_control/features/meal/logic/meal_bloc.dart';
import '../features/addition/logic/addition_bloc.dart';
import '../features/admin/logic/admins_bloc.dart';
import '../features/group/logic/group_bloc.dart';
import '../features/orders/logic/orders_bloc.dart';
import '../features/second_navigation_bar/second_nav_bar_cubit.dart';
import '../features/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import '../features/my_drawer/my_drawer_cubit.dart';
import '../features/settings/logic/settings_bloc.dart';
import 'localization_config.dart';

class BlocsConfig extends StatelessWidget {
  const BlocsConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MyDrawerCubit()),
        BlocProvider(create: (context) => AdminsBloc()),
        BlocProvider(create: (context) => SettingsBloc()),
        BlocProvider(create: (context) => BottomNavBarCubit()),
        BlocProvider(create: (context) => SecondNavBarCubit()),
        BlocProvider(create: (context) => GroupsBloc()),
        BlocProvider(create: (context) => AdditionsBloc()),
        BlocProvider(create: (context) => MealsBloc()),
        BlocProvider(create: (context) => OrdersBloc()),
        BlocProvider(create: (context) => MakeOrderBloc()),
        BlocProvider(create: (context) => AnalyticsBloc()),
      ],
      child: const LocalizationConfig(),
    );
  }
}
