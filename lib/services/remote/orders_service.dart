
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya_control/features/orders/model/order.dart' as o;

import '../../constants/texts.dart';

class OrdersRemoteService {
  static OrdersRemoteService get() => OrdersRemoteService();

  CollectionReference orders = FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
      .collection('orders');

  Stream<QuerySnapshot<Object?>> getStreamOrders(String state) {
    DateTime date = DateTime.now();
    Timestamp start =
        Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    return orders
        .where('date', isGreaterThanOrEqualTo: start)
        .orderBy('date', descending: false)
        .snapshots();
  }

  // Future<List<o.Order>> getOrders(String state) async {
  //   List<o.Order> ordersList = [];
  //   try {
  //     final data = await orders
  //         .where('state', isEqualTo: state)
  //         .orderBy('date', descending: true)
  //         .get();
  //
  //     if (data.docs.isNotEmpty) {
  //       for (QueryDocumentSnapshot order in data.docs) {
  //         var m = order.get('meals');
  //         Map<String, dynamic> mmm = m;
  //         Map<String, int> meals = mmm.map((key, value) {
  //           return MapEntry(key, value);
  //         });
  //
  //         var a = order.get('additions');
  //         mmm = a;
  //         Map<String, int> additions = mmm.map((key, value) {
  //           return MapEntry(key, value);
  //         });
  //         Timestamp timestamp = order.get('date');
  //
  //         ordersList.add(o.Order(
  //           meals: meals,
  //           additions: additions,
  //           userEmail: order.get('userEmail'),
  //           userName: order.get('userName'),
  //           state: order.get('state'),
  //           note: order.get('note'),
  //           token: order.get('token'),
  //           paymentMethod: order.get('paymentMethod'),
  //           totalPrice: order.get('totalPrice'),
  //         ));
  //         ordersList.last.setDate(timestamp.toDate());
  //         ordersList.last.setId(order.get('id'));
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //     EasyLoading.showError(TextKeys.sorryError.tr());
  //   }
  //   return ordersList;
  // }

  Future<List<o.Order>> getOldOrders(String state, DateTime start,DateTime end) async {
    List<o.Order> ordersList = [];
    try {
      Timestamp startDStamp =
              Timestamp.fromDate(DateTime(start.year, start.month, start.day)),
          endStamp = Timestamp.fromDate(
              DateTime(end.year, end.month, end.day,23,59));
      final data = await orders
          .where('state', isEqualTo: state)
          .where('date', isGreaterThanOrEqualTo: startDStamp)
          .where('date', isLessThan: endStamp)
          .orderBy('date', descending: true)
          .get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot order in data.docs) {
          ordersList.add(o.Order.fromMap(order: order));
        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return ordersList;
  }

  Future<bool> addOrder(o.Order order) async {
    try {
      await orders.doc(order.id).set(order.toMap());
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }

  Future<bool> updateOrder(o.Order order) async {
    try {
      await orders.doc(order.id).update(order.toMap());
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }

  Future<bool> deleteOrder(String id) async {
    try {
      await orders.doc(id).delete();
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
    return true;
  }
}
