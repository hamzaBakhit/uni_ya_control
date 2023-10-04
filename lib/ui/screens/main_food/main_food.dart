import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/group/logic/group_bloc.dart';
import 'package:uni_ya_control/features/meal/logic/meal_bloc.dart';
import 'package:uni_ya_control/features/meal/view/meals_screen.dart';
import 'package:uni_ya_control/services/remote/notifications.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';
import '../../../features/addition/logic/addition_bloc.dart';
import '../../../features/addition/view/addition_screen.dart';
import '../../../features/group/view/categories_screen.dart';
import '../../../features/second_navigation_bar/second_nav_bar_cubit.dart';
import '../../../features/second_navigation_bar/view/second_navigation_bar.dart';

import '../../../features/group/view/offers_screen.dart';

class MainFood extends StatefulWidget {
  const MainFood({Key? key}) : super(key: key);

  @override
  State<MainFood> createState() => _MainFoodState();
}

class _MainFoodState extends State<MainFood> {
  @override
  void initState() {
    MyNotifications.get.sendMessageToAdmins(orderId: 'kkk', isAdd: true);
    context.read<AdditionsBloc>().add(GetAdditions());
    context.read<GroupsBloc>().add(GetGroups());
    context.read<MealsBloc>().add(GetMeals());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: const [
              OffersScreen(),
              CategoriesScreen(),
              MealsScreen(),
              AdditionsScreen()
            ][context.watch<SecondNavBarCubit>().state]),
            const SecondNavBar(),
          ],
        ),
      ),
    );
  }
}
