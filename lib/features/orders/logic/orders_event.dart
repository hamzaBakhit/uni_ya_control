part of 'orders_bloc.dart';

class OrdersEvent {}

class ChangeOrder extends OrdersEvent {
  Order order;

  ChangeOrder(this.order);
}

class CancelOrder extends OrdersEvent {
  Order order;

  CancelOrder(this.order);
}

class GetOrders extends OrdersEvent {
  String state;

  GetOrders(this.state);
}
class GetOldOrders extends OrdersEvent {
  String state;
  DateTime date;

  GetOldOrders(this.state, this.date);
}

class AddOrder extends OrdersEvent {
  Order order;

  AddOrder(this.order);
}
