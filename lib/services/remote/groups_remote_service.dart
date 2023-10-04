import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya_control/constants/texts.dart';

import '../../features/group/model/group.dart';

class GroupsRemoteService {
  static GroupsRemoteService get() => GroupsRemoteService();

  final groups = FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
      .collection('groups');

  Future<List<Group>> getGroups() async {
    List<Group> groupsList = [];
    try {
      final data = await groups.get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot group in data.docs) {

          groupsList.add(Group(
            title: group.get('title'),
            img: group.get('img'),
            isOffer: group.get('isOffer'),
          ));
          int color = group.get('color');
          groupsList.last.setColor(color);
          groupsList.last.setId(group.get('id'));
        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return groupsList;
  }

  Future<bool> addGroup(Group group) async {
    try {
      await groups.doc(group.id).set({
        'title': group.title,
        'img': group.img,
        'id': group.id,
        'isOffer': group.isOffer,
        'color': group.getColor(),
      });
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }

  Future<bool> updateGroup(Group group) async {
    try {
      await groups.doc(group.id).update({
        'title': group.title,
        'img': group.img,
        'isOffer': group.isOffer,
        'color': group.getColor(),
      });
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }

  Future<bool> deleteGroup(String id) async {
    try {
      await groups.doc(id).delete();
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
    return true;
  }

}
