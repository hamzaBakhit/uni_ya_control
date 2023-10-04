import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/ui/widgets/loading.dart';

import '../../../constants/texts.dart';
import '../../../ui/widgets/delete_alert.dart';
import '../logic/meal_bloc.dart';
import '../model/meal.dart';
import 'edit_meal_screen.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(TextKeys.meals.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<MealsBloc, MealsState>(builder: (context, state) {
        return Stack(
          children: [
            ListView(
              children: state.meals
                  .map((e) => Column(
                        children: [
                          MealItem(meal: e),
                          Divider(),
                        ],
                      ))
                  .toList(),
            ),
            if (state is MealsProcess)
              const LoadingWidget(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditMealScreen()));
        },
        label: Text(TextKeys.add.tr()),
        icon: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  MealItem({required this.meal, Key? key}) : super(key: key);
  Meal meal;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(meal.id),
      confirmDismiss: (direction) async {
        return await showDialog(
            context: context,
            builder: (context) => DeleteAlert(
              title: TextKeys.areYouSure.tr(),
              actionTitle: TextKeys.delete.tr(),
              description: TextKeys.deleteDialogDescription.tr(),
              actionColor: Colors.redAccent,
            ));
      },
      onDismissed: (direction) =>context.read<MealsBloc>().add(DeleteMeal(meal.id)),
      background: Container(
        color: Colors.redAccent.withOpacity(0.7),
        alignment: Alignment.center,
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditMealScreen(meal: meal)));
        },
        title: Text(meal.title),

        trailing: Text('${meal.price.toStringAsFixed(2)} \$'),
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 30,
          child: Container(
            margin: EdgeInsets.all(8),
            child: Image.network(
              meal.img,
              errorBuilder: (context, error, stackTrace) => Container(),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
