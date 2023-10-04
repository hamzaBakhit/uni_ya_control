part of'meal_bloc.dart';

class MealsState extends Equatable{
  List<Meal> meals;
  MealsState(this.meals);
  @override
  List<Object?> get props => [meals];
}
class MealsShow extends MealsState{
  MealsShow(super.meals);
}
class MealsProcess extends MealsState{
  MealsProcess(super.meals);
}

