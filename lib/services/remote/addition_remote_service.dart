import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants/texts.dart';
import '../../features/addition/model/addition.dart';

class AdditionsRemoteService {
  static AdditionsRemoteService get() => AdditionsRemoteService();

  CollectionReference additions =FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
.collection('additions');

  Future<List<Addition>> getAdditions() async {
    List<Addition> additionsList = [];
    try {
      final data = await additions.get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot addition in data.docs) {
          additionsList.add(Addition(
            title: addition.get('title'),
            img: addition.get('img'),
            price: addition.get('price'),
          ));
          additionsList.last.setId(addition.get('id'));
        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return additionsList;
  }

  Future<bool> addAddition(Addition addition) async {
    try {
      await additions.doc(addition.id).set({
        'id':addition.id,
        'title': addition.title,
        'img': addition.img,
        'price': addition.price,
      });
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());

      return false;
    }
  }

  Future<bool> updateAddition(Addition addition) async {
    try {
      await additions.doc(addition.id).update({
        'title': addition.title,
        'img': addition.img,
        'price': addition.price,
      });
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }

  Future<bool> deleteAddition(String id) async {
    try {
      await additions.doc(id).delete();
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());

      return false;
    }
    return true;
  }
}
