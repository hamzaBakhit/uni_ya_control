import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/services/remote/notifications.dart';

import '../../../services/remote/orders_service.dart';
import '../model/order.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersProcess(order: [])) {
    on<GetOrders>(_getOrders);
    on<GetOldOrders>(_getOldOrders);

    on<ChangeOrder>(_change);
    on<AddOrder>(_add);
    on<CancelOrder>(_cancel);
    // add(GetOrders(OrderState.finished));
    // add(GetOrders(OrderState.unfinished));
    // add(GetOldOrders(OrderState.canceled,DateTime.now()));
    // add(GetOldOrders(OrderState.completed,DateTime.now()));
  }

  static Stream<fb.QuerySnapshot<Object?>> data =
      OrdersRemoteService.get().getStreamOrders(OrderState.unfinished);

  _getOrders(GetOrders event, Emitter<OrdersState> emit) async {
    emit(OrdersProcess(order: state.order));
    List<Order> orders = [];
    orders = state.order;
    // orders = await OrdersRemoteService.get().getOrders(event.state);
    if (orders.isEmpty) {
      emit(OrdersShow(order: state.order));
    } else {
      emit(OrdersShow(order: orders));
    }
  }

  _getOldOrders(GetOldOrders event, Emitter<OrdersState> emit) async {
    emit(OrdersProcess(order: state.order));
    List<Order> orders = [];
    orders = state.order;
    // orders=await OrdersRemoteService.get().getOldOrders(event.state,event.date);
    if (orders.isEmpty) {
      emit(OrdersShow(order: state.order));
    } else {
      emit(OrdersShow(order: orders));
    }
  }

  _change(ChangeOrder event, Emitter<OrdersState> emit) async {
    emit(OrdersProcess(order: state.order));
    List<Order> orders = [];
    orders = state.order;
    bool isDone = await OrdersRemoteService.get().updateOrder(event.order);
    if (isDone) {
        MyNotifications.get.sendMessageToUser(
            order:event.order);


      orders.removeWhere((e) => e.id == event.order.id);
      orders.add(event.order);
      emit(OrdersShow(order: state.order));
    } else {
      emit(OrdersShow(order: orders));
    }
  }

  _add(AddOrder event, Emitter<OrdersState> emit) async {
    emit(OrdersProcess(order: state.order));
    List<Order> orders = [];
    orders = state.order;
    bool isDone = await OrdersRemoteService.get().addOrder(event.order);
    if (isDone) {
      orders.add(event.order);
      emit(OrdersShow(order: state.order));
    } else {
      emit(OrdersShow(order: orders));
    }
  }

  _cancel(CancelOrder event, Emitter<OrdersState> emit) async {
    emit(OrdersProcess(order: state.order));
    List<Order> orders = [];
    orders = state.order;
    bool isDone = await OrdersRemoteService.get().deleteOrder(event.order.id);
    if (isDone) {
      orders.remove(event.order);
      emit(OrdersShow(order: state.order));
    } else {
      emit(OrdersShow(order: orders));
    }
  }
}
