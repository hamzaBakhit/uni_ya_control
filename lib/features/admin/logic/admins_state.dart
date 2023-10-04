
part of'admins_bloc.dart';

abstract class AdminsState extends Equatable{
  Admin myAdmin;
  List<Admin> allAdmins;
  AdminsState({required this.myAdmin,required this.allAdmins});
  @override
  List<Object?> get props => [myAdmin,allAdmins];
}


class AdminsLogIn extends AdminsState{
  AdminsLogIn({required super.myAdmin, required super.allAdmins});
}
class AdminsProcess extends AdminsState{
  AdminsProcess({required super.myAdmin, required super.allAdmins});
}

class AdminsShow extends AdminsState {
  AdminsShow({required super.myAdmin, required super.allAdmins});
}