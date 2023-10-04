import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/constants/texts.dart';
import 'package:uni_ya_control/features/admin/logic/admins_bloc.dart';
import 'package:uni_ya_control/services/remote/notifications.dart';

import '../../constants/routes.dart';
import 'my_drawer_cubit.dart';

class MyDrawerScreen extends StatelessWidget {
  const MyDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.15,
                backgroundImage: const  AssetImage('assets/images/logo.jpg')),
          ),
          Text('Yallah',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  fontWeight: FontWeight.bold,
                  fontSize: 32)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          const Expanded(child: MyDrawerBody()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                onPressed: () {
                  context.read<MyDrawerCubit>().toggle();
                  context.read<AdminsBloc>().add(LogOutAdmin());
                  Navigator.pushReplacementNamed(context, Routes.logIn);
                },
                child: Text(
                  TextKeys.logOut.tr(),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color!),
                ),
                style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(BorderSide(
                        color:
                            Theme.of(context).textTheme.bodyLarge!.color!)))),
          ),
        ],
      ),
    );
  }
}

class MyDrawerBody extends StatelessWidget {
  const MyDrawerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
        title:  Text(TextKeys.makeOrder.tr()),
        onTap: () {
          Navigator.pushNamed(context, Routes.makeOrderHome);
        },
        leading: Icon(Icons.add),
      ),
        ListTile(
        title:  Text(TextKeys.orders.tr()),
        onTap: () {
          context.read<MyDrawerCubit>().toggle();
        },
        leading: Icon(Icons.shopping_bag_outlined),
      ),
        if (context.read<AdminsBloc>().state.myAdmin.level >= 2)
          ListTile(
            title: Text(TextKeys.meals.tr()),
            onTap: () {
              Navigator.pushNamed(context, Routes.mainFood);
            },
            leading: Icon(Icons.fastfood_outlined),
          ),
        if(context.read<AdminsBloc>().state.myAdmin.level>=2)
        ListTile(
          title:  Text(TextKeys.history.tr()),
          onTap: () {
            Navigator.pushNamed(context, Routes.oldOrders);
          },
          leading: Icon(Icons.timeline_rounded),
        ),
        if (context.read<AdminsBloc>().state.myAdmin.level == 3)
          ListTile(
            title: Text(TextKeys.admins.tr()),
            onTap: () {
              Navigator.pushNamed(context, Routes.admins);
            },
            leading: Icon(Icons.admin_panel_settings_rounded),
          ),
        ListTile(
          title: Text(TextKeys.settings.tr()),
          onTap: () {
            Navigator.pushNamed(context, Routes.settings);
            context.read<MyDrawerCubit>().toggle();
          },
          leading: Icon(Icons.settings),
        ),
      ],
    );
  }
}
