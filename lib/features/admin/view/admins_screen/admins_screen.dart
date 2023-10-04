import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uni_ya_control/constants/texts.dart';
import 'package:uni_ya_control/features/admin/logic/admins_bloc.dart';
import 'package:uni_ya_control/features/admin/view/admins_screen/add_admin_dialog.dart';
import 'package:uni_ya_control/services/connection.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';
import 'package:uni_ya_control/ui/widgets/delete_alert.dart';
import 'package:uni_ya_control/ui/widgets/loading.dart';

import '../../model/admin.dart';

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({Key? key}) : super(key: key);

  @override
  State<AdminsScreen> createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<AdminsScreen> {
  @override
  RefreshController controller=RefreshController();
  void initState() {
    context.read<AdminsBloc>().add(GetAllAdmin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  BackgroundWidget(
      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          title: Text(TextKeys.admins.tr()),
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                        ),
                        body: BlocBuilder<AdminsBloc, AdminsState>(
                            builder: (context, state) {
                          return Stack(
                            children: [
                              SmartRefresher(
                                controller: controller,
                                onRefresh: (){
                                  context.read<AdminsBloc>().add(GetAllAdmin());
                                  if(state is AdminsShow&& controller.isRefresh){
                                   controller.refreshCompleted();
                                  }
                                },
                                enablePullDown: true,
                                enablePullUp: true,
                                header: WaterDropHeader(),
                                child: ListView(
                                  children: state.allAdmins
                                      .map((e) => Column(
                                            children: [
                                              AdminItem(admin: e),
                                              Divider(),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                              if (state is AdminsProcess) const LoadingWidget(),
                            ],
                          );
                        }),
                        floatingActionButton: FloatingActionButton.extended(
                          onPressed: () async {
                            if (await checkConnection(context)) {
                              showDialog(
                                context: context,
                                builder: (context) => const AddAdminDialog(),
                              );
                            }
                          },
                          label: Text(TextKeys.add.tr()),
                          icon: Icon(Icons.add),
                          backgroundColor: Colors.black,
                        ),
                      ),
    );
  }
}

class AdminItem extends StatelessWidget {
  AdminItem({required this.admin, Key? key}) : super(key: key);
  Admin admin;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(admin.name),
      subtitle: Text('${TextKeys.adminLevel.tr()} : ${admin.level}'),
      trailing: IconButton(
        onPressed: () async {
          if (await checkConnection(context)) {
            var isConfirm = await showDialog(
                context: context,
                builder: (context) => DeleteAlert(
                      title: TextKeys.areYouSure.tr(),
                      actionTitle: TextKeys.delete.tr(),
                      description: TextKeys.deleteDialogDescription.tr(),
                      actionColor: Colors.redAccent,
                    ));

            if (isConfirm) {
              context.read<AdminsBloc>().add(DeleteAdmin(admin.name));
            }
          }
        },
        icon: Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
