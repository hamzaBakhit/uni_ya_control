part of 'meal_bloc.dart';

class MealsEvent {}

class GetMeals extends MealsEvent {}

class AddMeal extends MealsEvent {
  Meal meal;
  File file;
  AddMeal(this.meal, this.file);
}

class DeleteMeal extends MealsEvent {
  String id;
  DeleteMeal(this.id);
}

class UpdateMeal extends MealsEvent {
  Meal meal;
  File? file;
  UpdateMeal(this.meal, this.file);
}
