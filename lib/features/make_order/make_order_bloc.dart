import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/meal/model/meal.dart';
import 'package:uni_ya_control/services/remote/orders_service.dart';

import '../addition/model/addition.dart';
import '../orders/model/order.dart';

part 'make_order_event.dart';

part 'make_order_state.dart';

class MakeOrderBloc extends Bloc<MakeOrderEvent, MakeOrderState> {
  MakeOrderBloc()
      : super(MakeOrderShow(
      additions: {}, meals: [], totalPrice: 0, additionCount: {})) {
    on<MakeOrder>(_make);
    on<AddOrder>(_add);
    on<ClearOrder>(_clear);
    on<DeleteAddition>(_deleteAddition);
    on<DeleteMeal>(_deleteMeal);
  }

  _make(MakeOrder event, Emitter<MakeOrderState> emit) async {
    emit(MakeOrderProcess(
      meals: state.meals,
      additions: state.additions,
      totalPrice: state.totalPrice,
      additionCount: state.additionCount,
    ));

    Order order = Order(
      additions: Order.getAdditions(state.additions),
      meals: Order.getMeals(state.meals),
      totalPrice: state.totalPrice,
      paymentMethod: PaymentMethod.cash,
      state: OrderState.finished,
      userName: 'The Cart',
      userEmail: 'The Cart',
    );
    order.setDate(DateTime.now());
    bool isDone=await OrdersRemoteService.get().addOrder(order);
    if(isDone){
      emit(MakeOrderShow(
          meals: [], additions: {}, totalPrice: 0, additionCount: {}));
    }else{
      emit(MakeOrderShow(
        meals: state.meals,
        additions: state.additions,
        totalPrice: state.totalPrice,
        additionCount: state.additionCount,));
    }


  }

  _add(AddOrder event, Emitter<MakeOrderState> emit) async {
    emit(MakeOrderProcess(
        meals: state.meals, additionCount: state.additionCount,

        additions: state.additions,
        totalPrice: state.totalPrice));
    List<Meal> meals = [];
    meals = state.meals;
    meals.removeWhere((e) => e.id == event.meal.id);
    meals.add(event.meal);

    Map<String, List<Addition>> additions = {};
    additions = state.additions;
    // additions.removeWhere((key, value) => key==event.meal.id);
    additions.addAll({event.meal.id: event.additions});
    Map<String, int>additionCount = {};
    additionCount = state.additionCount;
    // additionCount.removeWhere((k,v)=>event.additionsCount.keys.contains(k));
    additionCount.addAll(event.additionsCount);

    double price = 0;

    meals.forEach((element) {
      price += element.price * element.count;
    });

    additionCount.forEach((key, value) {
      double addPrice=0;
      additions.values.forEach((element) {
        element.forEach((e) {
          if (key.contains(e.id)){
            addPrice=e.price;
          }
        });
      });
      price+=addPrice*value;
    });

    emit(MakeOrderShow(meals: meals.reversed.toList(),
      additions: additions,
      totalPrice: price,
      additionCount: additionCount,
    ));
  }

 _deleteAddition(DeleteAddition event, Emitter<MakeOrderState> emit) async {
    emit(MakeOrderProcess(
        meals: state.meals, additionCount: state.additionCount,
        additions: state.additions,
        totalPrice: state.totalPrice));


    Map<String, List<Addition>> additions = {};
    additions = state.additions;
    List<Addition> oldAdditions=additions[event.mealId]!;
    oldAdditions.removeWhere((element) => element.id==event.AdditionId);
    additions.addAll({event.mealId: oldAdditions});

    Map<String, int>additionCount = {};
    additionCount = state.additionCount;
    additionCount.removeWhere((key, value) => key==event.mealId+'=='+event.AdditionId);

    double price = 0;
    List<Meal> meals = state.meals;
    meals.forEach((element) {
      price += element.price * element.count;
    });

    additionCount.forEach((key, value) {
      double addPrice=0;
      additions.values.forEach((element) {
        element.forEach((e) {
          if (key.contains(e.id)){
            addPrice=e.price;
          }
        });
      });
      price+=addPrice*value;
    });

    emit(MakeOrderShow(meals: meals.reversed.toList(),
      additions: additions,
      totalPrice: price,
      additionCount: additionCount,
    ));
  }

 _deleteMeal(DeleteMeal event, Emitter<MakeOrderState> emit) async {
    emit(MakeOrderProcess(
        meals: state.meals,
        additionCount: state.additionCount,
        additions: state.additions,
        totalPrice: state.totalPrice,));

    List<Meal> meals = [];
    meals = state.meals;
    meals.removeWhere((e) => e.id == event.mealId);


    Map<String, List<Addition>> additions = {};
    additions = state.additions;
    additions.removeWhere((key, value) => key==event.mealId);

    Map<String, int>additionCount = {};
    additionCount = state.additionCount;
    additionCount.removeWhere((key, value) => key.contains(event.mealId));

    double price = 0;
    meals.forEach((element) {
      price += element.price * element.count;
    });

    additionCount.forEach((key, value) {
      double addPrice=0;
      additions.values.forEach((element) {
        element.forEach((e) {
          if (key.contains(e.id)){
            addPrice=e.price;
          }
        });
      });
      price+=addPrice*value;
    });

    emit(MakeOrderShow(meals: meals,
      additions: additions,
      totalPrice: price,
      additionCount: additionCount,
    ));
  }


  _clear(ClearOrder event, Emitter<MakeOrderState> emit) {
    emit(MakeOrderProcess(additionCount: state.additionCount,
        meals: state.meals,
        additions: state.additions,
        totalPrice: state.totalPrice));
    emit(MakeOrderShow(
      meals: [], additions: {}, totalPrice: 0, additionCount: {},
    ));
  }
}
