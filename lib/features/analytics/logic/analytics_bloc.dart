import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/addition/model/addition.dart';
import 'package:uni_ya_control/features/orders/model/order.dart';

import '../../../services/remote/orders_service.dart';
import '../../meal/model/meal.dart';

part 'analytics_event.dart';

part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(AnalyticsShow()) {
    on<GetOrders>(_getOrders);
  }

  List<Order> orders = [];
  Map<String, double> methodMoney = {
        PaymentMethod.cash: 0,
        PaymentMethod.visa: 0,
        PaymentMethod.google: 0,
        PaymentMethod.apple: 0,
      },
      methodCount = {
        PaymentMethod.cash: 0,
        PaymentMethod.visa: 0,
        PaymentMethod.google: 0,
        PaymentMethod.apple: 0,
      },
      placeMoney = {
        'Application': 0,
        'Cart': 0,
      },
      placeCount = {
        'Application': 0,
        'Cart': 0,
      };
  List<AnalyticData> analyticAllMeals = [],
      analyticMeals = [],
      analyticAdditions = [],
      analyticOrders = [];

  _getOrders(GetOrders event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsDownloading());
    orders=await OrdersRemoteService.get().getOldOrders(OrderState.completed, event.start, event.end);
    // orders = List.generate(200, (index) {
    //   int r = getRandom();
    //   allMeals.shuffle();
    //   List<Meal> _meals = allMeals.sublist(0, getRandom(max: 4) + 1);
    //   double price = 0;
    //   _meals.forEach((element) {
    //     price = price + element.price;
    //   });
    //   Order order = Order(
    //     state: OrderState.completed,
    //     paymentMethod: (r < 50)
    //         ? PaymentMethod.cash
    //         : (r < 70)
    //             ? PaymentMethod.google
    //             : (r < 90)
    //                 ? PaymentMethod.apple
    //                 : PaymentMethod.cash,
    //     userEmail: (r < 60) ? 'user_${r}@mail.com' : 'The Cart',
    //     userName: 'user_$r',
    //     totalPrice: price,
    //     additions: Order.getAdditions({
    //       '1': [
    //         additions[r % 15],
    //         additions[r % 4],
    //         additions[r % 11],
    //       ],
    //       '2': [
    //         additions[r % 14],
    //         additions[r % 13],
    //         additions[r % 9],
    //       ],
    //       '3': [
    //         additions[r % 10],
    //         additions[r % 7],
    //         additions[r % 8],
    //       ],
    //     }),
    //     meals: Order.getMeals(_meals),
    //   );
    //
    //   order.setDate(DateTime(2022, 12, r % 31, 8 + r % 8));
    //   return order;
    // });
    emit(AnalyticsShow());
    _analytic(orders);
  }

  _analytic(List<Order> orders) {
    methodMoney = {
      PaymentMethod.cash: 0,
      PaymentMethod.visa: 0,
      PaymentMethod.google: 0,
      PaymentMethod.apple: 0,
    };
    methodCount = {
      PaymentMethod.cash: 0,
      PaymentMethod.visa: 0,
      PaymentMethod.google: 0,
      PaymentMethod.apple: 0,
    };
    placeMoney = {
      'Application': 0,
      'Cart': 0,
    };
    placeCount = {
      'Application': 0,
      'Cart': 0,
    };
    orders.sort((a, b) => a.orderDate.compareTo(b.orderDate));
    for (Order order in orders) {
      methodCount.update(order.paymentMethod, (value) => value + 1);
      methodMoney.update(
          order.paymentMethod, (value) => value + order.totalPrice);
      placeCount.update(order.userEmail != 'The Cart' ? 'Application' : 'Cart',
          (value) => value + 1);
      placeMoney.update(order.userEmail != 'The Cart' ? 'Application' : 'Cart',
          (value) => value + order.totalPrice);
    }
  }
}

int getRandom({int max = 100}) {
  return Random().nextInt(max);
}

DateTime getDate(DateTime date) => DateTime(date.year, date.month, date.day);

List<Meal> allMeals = List.generate(
    25,
    (index) => Meal(
        title: 'Meal $index',
        img: '',
        price: 10.0 + (1.5 * index),
        count: getRandom(max: 3)+1,
        additions: [],
        groups: []));
List<Addition> additions = List.generate(
    15,
    (index) => Addition(
        title: 'Addition $index', img: '', price: 1.0 + (0.5 * index),count: getRandom(max: 3)+1));

class AnalyticData extends Equatable {
  String id, title, img;
  int count;
  double price;
  DateTime date;

  AnalyticData(
      this.id, this.title, this.count, this.price, this.date, this.img);

  addOne(double price, {int count = 1}) {
    if (count == 1) {
      this.count += count;
      this.price += price;
    } else {
      this.price += price * count;
      this.count += count;
    }
  }

  @override
  List<Object?> get props =>
      [this.id, this.title, this.count, this.price, this.date];
}
