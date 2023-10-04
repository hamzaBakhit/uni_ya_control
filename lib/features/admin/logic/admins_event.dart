
part of'admins_bloc.dart';

class AdminsEvent{}
class RememberAdmin extends AdminsEvent{}
class LogInAdmin extends AdminsEvent{
  String name,password;
  bool remember;
  LogInAdmin({required this.name,required this.password,required this.remember});
}
class AddAdmin extends AdminsEvent{
  Admin admin;
  AddAdmin(this.admin);
}
class DeleteAdmin extends AdminsEvent{
  String name;
  DeleteAdmin(this.name);
}
class GetAllAdmin extends AdminsEvent{}
class LogOutAdmin extends AdminsEvent{}