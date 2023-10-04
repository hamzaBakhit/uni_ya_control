import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya_control/services/local/local_service.dart';

import '../../../services/remote/admins_remote_service.dart';
import '../model/admin.dart';

part 'admins_event.dart';

part 'admins_state.dart';

class AdminsBloc extends Bloc<AdminsEvent, AdminsState> {
  AdminsBloc()
      : super(AdminsProcess(
            myAdmin: Admin(name: '', password: ''), allAdmins: [])) {
    _remember();
    on<LogInAdmin>(_logIn);
    on<LogOutAdmin>(_logOut);
    on<GetAllAdmin>(_getAll);
    on<AddAdmin>(_add);
    on<DeleteAdmin>(_delete);

  }

  _remember() async {
    late List<String> adminParameter;
    adminParameter = await LocalService.get.rememberAdmin();
    print(adminParameter);
    Admin? admin =
        await AdminsRemoteService.get().getAdmin(name: adminParameter[0]);
    if (admin != null && admin.password == adminParameter[1]) {
      emit(AdminsShow(myAdmin: admin, allAdmins: state.allAdmins));
    }else{
      print('jjj');
      EasyLoading.dismiss();
      emit(AdminsLogIn(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    }
  }

  _logIn(LogInAdmin event, Emitter<AdminsState> emit) async {
    emit(AdminsProcess(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    Admin? admin = await AdminsRemoteService.get().getAdmin(name: event.name);
    if (admin == null || admin.password != event.password) {
      EasyLoading.showError('Error', duration: Duration(milliseconds: 500));
      emit(AdminsLogIn(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    } else {

      if (event.remember) {
        print('yy');
        await LocalService.get
          .setLocalData({'name': event.name, 'password': event.password});
      } else {
        print('ddd');
        await LocalService.get.deleteLocalData(['name','password']);
      }
      emit(AdminsShow(myAdmin: admin, allAdmins: state.allAdmins));
    }
  }
_logOut(LogOutAdmin event, Emitter<AdminsState> emit) async {
    emit(AdminsProcess(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    await LocalService.get.deleteLocalData(['name','password']);
        emit(AdminsLogIn( myAdmin: Admin(name: '', password: ''), allAdmins: []));
    }
  _getAll(GetAllAdmin event, Emitter<AdminsState> emit)async {
    emit(AdminsProcess(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    List<Admin> admins = [];
    admins = await AdminsRemoteService.get().getAdmins();
    if (admins.isEmpty) {
      emit(AdminsShow(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    } else {
      emit(AdminsShow(myAdmin: state.myAdmin, allAdmins: admins));
    }
  }
  _add(AddAdmin event, Emitter<AdminsState> emit)async {
    emit(AdminsProcess(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    List<Admin> admins = [];
    admins=state.allAdmins;
    if(admins.map((e) => e.name).contains(event.admin.name)){
      EasyLoading.showError('can\'t add this admin');
    }else{
      bool isDone = await AdminsRemoteService.get().addAdmin(event.admin);
      if (isDone) {
        admins.add(event.admin);
      }
    }
    emit(AdminsShow(myAdmin: state.myAdmin, allAdmins: admins));
  }
  _delete(DeleteAdmin event, Emitter<AdminsState> emit) async{
    emit(AdminsProcess(myAdmin: state.myAdmin, allAdmins: state.allAdmins));
    List<Admin> admins = state.allAdmins;
    bool isDone = await AdminsRemoteService.get().deleteAdmin(event.name);
    if (isDone) {
      EasyLoading.showSuccess('Admin is deleted');
      admins.removeWhere((element) => element.name == event.name);
    } else {
      EasyLoading.showError('Can\'t delete Admin');
    }
    emit(AdminsShow(myAdmin: state.myAdmin, allAdmins: admins));
  }
}
