// import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/make_order/make_order_bloc.dart';

import '../../../../constants/routes.dart';
import '../../../../constants/texts.dart';
import '../../../../features/addition/logic/addition_bloc.dart';
import '../../../../features/meal/logic/meal_bloc.dart';
import '../../../widgets/backgruond.dart';
import 'group_body.dart';

class MakeOrderHome extends StatefulWidget {
  const MakeOrderHome({Key? key}) : super(key: key);

  @override
  State<MakeOrderHome> createState() => _MakeOrderHomeState();
}

class _MakeOrderHomeState extends State<MakeOrderHome> {
  final TextEditingController _controller = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    context.read<AdditionsBloc>().add(GetAdditions());
    context.read<MealsBloc>().add(GetMeals());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Badge(
                backgroundColor: Colors.black,
                 isLabelVisible:  context.watch<MakeOrderBloc>().state.meals.isNotEmpty,
                  label:  Text(
                  context.watch<MakeOrderBloc>().state.meals.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                    onPressed: ()=>Navigator.pushNamed(context, Routes.orderDetails), icon: Icon(Icons.shopping_cart_outlined)),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => setState(() {
                  searchText = value;
                }),
                controller: _controller,
                decoration: InputDecoration(
                  hintText: TextKeys.searchHint.tr(),
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).textTheme.bodyLarge!.color!)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
              ),
            ),
            Expanded(child: GroupBody(searchText))
          ],
        ),
      ),
    );
  }
}
