import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants/texts.dart';
import '../../features/meal/model/meal.dart';

class MealsRemoteService {
  static MealsRemoteService get() => MealsRemoteService();

  CollectionReference meals =FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
.collection('meals');

  Future<List<Meal>> getMeals() async {
    List<Meal> mealsList = [];
    try {
      final data = await meals.get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot meal in data.docs) {
          List groups=meal.get('groups') ;

          List additions=meal.get('additions') ;
          mealsList.add(Meal(
            additions: additions.map((e) => e.toString()).toList(),
            groups: groups.map((e) => e.toString()).toList(),
            title: meal.get('title'),
            img: meal.get('img'),
            price: meal.get('price'),
            description: meal.get('description'),
            rateScore: meal.get('rateScore'),
            rateCount: meal.get('rateCount'),
          ));
          mealsList.last.setId(meal.get('id'));
        }
      }
    } catch (e) {
      print(e);
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return mealsList;
  }

  Future<bool> addMeal(Meal meal) async {
    try {
      await meals.doc(meal.id).set({
        'id':meal.id,
        'title': meal.title,
        'img': meal.img,
        'price': meal.price,
        'description': meal.description,
        'rateScore': meal.rateScore,
        'rateCount': meal.rateCount,
        'groups':meal.groups,
        'additions':meal.additions,
      });
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());

      return false;
    }
  }

  Future<bool> updateMeal(Meal meal) async {
    try {
      await meals.doc(meal.id).update({
        'title': meal.title,
        'img': meal.img,
        'price': meal.price,
        'description': meal.description,
        'groups':meal.groups,
        'additions':meal.additions,
      });
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }

  Future<bool> deleteMeal(String id) async {
    try {
      await meals.doc(id).delete();
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
    return true;
  }
}
