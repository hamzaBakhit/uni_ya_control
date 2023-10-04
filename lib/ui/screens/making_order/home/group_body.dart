import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/meal/logic/meal_bloc.dart';
import 'package:uni_ya_control/ui/widgets/empty.dart';
import 'package:uni_ya_control/ui/widgets/loading.dart';

import '../../../../features/meal/model/meal.dart';
import '../../../widgets/cached_image.dart';
import '../details_screen/details_screen.dart';

class GroupBody extends StatelessWidget {
  GroupBody(this.searchText, {Key? key}) : super(key: key);
  String searchText;

  @override
  Widget build(BuildContext context) {
    List<Meal> meals=[];

    return Container(
      child: BlocBuilder<MealsBloc, MealsState>(builder: (context, state) {
        if(state is MealsProcess){
          return LoadingWidget();
        }
        meals=state.meals.where((element) => element.title.contains(searchText)).toList();
        if(meals.isEmpty){
          return EmptyScreen();
        }
        return GridView(
          gridDelegate:
              SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 350),
          children: meals.map((e) => GroupItem(meal: e)).toList(),
        );
      }),
    );
  }
}

class GroupItem extends StatelessWidget {
  GroupItem({
    required this.meal,
    Key? key,
  }) : super(key: key);
  Meal meal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Container(
        padding: EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(meal),
              )),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: constrains.maxWidth,
                    height: constrains.maxHeight * 4 / 6,
                    padding: EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 2,
                                  color: Colors.white.withOpacity(0.5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(flex: 2,child: SizedBox()),
                              Expanded(
                                child: Text(meal.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(child:Row(
                                children: [
                                  Text(
                                    '${meal.price.toStringAsFixed(2)} \$',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Icon(Icons.star, color: Colors.orangeAccent),
                                  Text(meal.rateScore.toString()),
                                ],
                              ) )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                top: 0,
                child: Container(
                  width: constrains.maxWidth * 4 / 6,
                  height: constrains.maxWidth * 4 / 6,
                  child: CachedImage(meal.img),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
