

import 'package:equatable/equatable.dart';

class Admin extends Equatable{
  String name;
  String password;
  String place;
  int level;

  Admin({required this.name,required this.password, this.level=1,this.place=''});

  @override
  List<Object?> get props =>[name,password,level,place];


}