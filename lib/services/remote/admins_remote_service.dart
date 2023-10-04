import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants/texts.dart';
import '../../features/admin/model/admin.dart';
import 'notifications.dart';

class AdminsRemoteService {
  static AdminsRemoteService get() => AdminsRemoteService();

  CollectionReference admins = FirebaseFirestore.instance.collection('admins');

  Future<Admin?> getAdmin({required String name, password}) async {
    try {
      DocumentSnapshot doc = await admins.doc(name.trim()).get();
      if (doc.exists) {
        return Admin(
          name: doc.get('name'),
          password: doc.get('password'),
          place: doc.get('place'),
          level: doc.get('level') as int,
        );
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return null;
  }

  Future<List<Admin>> getAdmins() async {
    List<Admin> adminsList = [];
    try {
      final data = await admins.get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot admin in data.docs) {
          adminsList.add(Admin(
            name: admin.get('name'),
            password: admin.get('password'),
            place: admin.get('place'),
            level: admin.get('level'),
          ));
        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return adminsList..removeWhere((element) => element.name == 'owner');
  }

  Future<bool> addAdmin(Admin admin) async {
    try {
      final data = await admins.doc(admin.name).get();
      if (data.exists) {
        return false;
      }
      await admins.doc(admin.name).set({
        'name': admin.name,
        'place': admin.place,
        'password': admin.password,
        'level': admin.level,
      });
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());

      return false;
    }
  }

  Future<bool> deleteAdmin(String name) async {
    try {
      await admins.doc(name).delete();
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());

      return false;
    }
    return true;
  }
}
