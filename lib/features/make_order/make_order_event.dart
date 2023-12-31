part of 'make_order_bloc.dart';

class MakeOrderEvent {}

class AddOrder extends MakeOrderEvent {
  Meal meal;
  List<Addition> additions;
  Map<String, int> additionsCount;

  AddOrder(
      {required this.meal,
      required this.additions,
      required this.additionsCount});
}

class MakeOrder extends MakeOrderEvent {}

class ClearOrder extends MakeOrderEvent {}

class DeleteMeal extends MakeOrderEvent {
  String mealId;

  DeleteMeal(this.mealId);
}

class DeleteAddition extends MakeOrderEvent {
  String mealId, AdditionId;

  DeleteAddition({required this.mealId, required this.AdditionId});
}
