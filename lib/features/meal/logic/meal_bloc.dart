import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/remote/meals_remote_service.dart';
import '../../../services/remote/storage_remote_service.dart';
import '../model/meal.dart';

part 'meal_event.dart';

part 'meal_state.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  MealsBloc() : super(MealsProcess(const [])) {
    on<GetMeals>(_get);
    on<DeleteMeal>(_delete);
    on<AddMeal>(_add);
    on<UpdateMeal>(_update);
    add(GetMeals());
  }

  _get(GetMeals event, Emitter<MealsState> emit) async {
    emit(MealsProcess(state.meals));
    List<Meal> meals = [];
    meals = await MealsRemoteService.get().getMeals();
    if (meals.isEmpty) {
      emit(MealsShow(state.meals));
    } else {
      emit(MealsShow(meals));
    }
  }

  _add(AddMeal event, Emitter<MealsState> emit) async {
    emit(MealsProcess(state.meals));
    List<Meal> meals =[];meals= state.meals;
    String img = await StorageService.get.addImage(
        id: event.meal.id, type: StorageType.meal, file: event.file);
    if (img.isNotEmpty) {
      event.meal.setImg(img);
      bool isDone = await MealsRemoteService.get().addMeal(event.meal);
      if (isDone) {
        meals.add(event.meal);
      } else {
        await StorageService.get
            .deleteImage(id: event.meal.id, type: StorageType.meal);
      }
    }
    emit(MealsShow(meals));
  }

  _delete(DeleteMeal event, Emitter<MealsState> emit) async {
    emit(MealsProcess(state.meals));
    List<Meal> meals = state.meals;
    bool imgDeleted = await StorageService.get
        .deleteImage(id: event.id, type: StorageType.meal);
    if (imgDeleted) {
      bool isDone = await MealsRemoteService.get().deleteMeal(event.id);
      if (isDone) {
        meals.removeWhere((element) => element.id == event.id);
      }
    }
    emit(MealsShow(meals));
  }

  _update(UpdateMeal event, Emitter<MealsState> emit) async {
    emit(MealsProcess(state.meals));
    List<Meal> meals = state.meals;
    if (event.file != null) {
      String img = await StorageService.get.addImage(
          id: event.meal.id, type: StorageType.meal, file: event.file!);
      if (img.isEmpty) {
        emit(MealsShow(meals));
        return;
      }
    }
    bool isDone = await MealsRemoteService.get().updateMeal(event.meal);
    if (isDone) {
      meals.removeWhere((element) => element.id == event.meal.id);
      meals.add(event.meal);
    }
    emit(MealsShow(meals));
  }
}
