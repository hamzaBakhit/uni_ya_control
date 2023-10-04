

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants/texts.dart';

class StorageService{
  static StorageService get=StorageService();


  final storage = FirebaseStorage.instance.ref();

  Future<String> addImage({required String id,required String type,required File file})async{
    try{
      final path= storage.child('$type/$id');
      await path.putFile(file);
      String url= await path.getDownloadURL();
      return(url);
    }catch(e){      EasyLoading.showError(TextKeys.sorryError.tr());

    return '';
    }
  }
  Future<bool> deleteImage({required String id,required String type})async{
    try{
      final path= storage.child('$type/$id');
      await path.delete();
      return true;
    }catch(e){      EasyLoading.showError(TextKeys.sorryError.tr());

    return false;
    }
  }

}

class StorageType{
  static const  String group='group';
  static const  String addition='addition';
  static const  String meal='meal';
}