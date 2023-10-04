import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/constants/texts.dart';
import 'package:uni_ya_control/features/admin/logic/admins_bloc.dart';
import 'package:uni_ya_control/features/admin/model/admin.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({Key? key}) : super(key: key);

  @override
  State<AddAdminDialog> createState() => _AddAdminDialogState();
}
class _AddAdminDialogState extends State<AddAdminDialog> {
  Admin admin = Admin(name: '', password: '');
  final _key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(),
      password = TextEditingController(),
      level = TextEditingController(text: '1');
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text(TextKeys.addAdmin.tr()),
        content: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                 validator: (value) {
                   if(value==null||value.isEmpty){
                     return TextKeys.emptyName.tr();
                   }
                 },
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(TextKeys.adminName.tr()),
              )),
              SizedBox(height: 8),
              TextFormField(
                  validator: (value) {
                    if(value==null||value.isEmpty){
                      return TextKeys.emptyPassword.tr();
                    }
                  },
                  controller: password,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(TextKeys.password.tr()),
                  )),
              SizedBox(height: 8),
              TextFormField(
                  validator: (value) {
                    if(value==null||value.isEmpty){
                      return TextKeys.emptyLevel.tr();
                    }else if(int.tryParse(value)==null||int.tryParse(value)!>2||int.tryParse(value)!<1){
                      return TextKeys.wrongLevel.tr();
                    }
                  },
                  controller: level,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(TextKeys.adminLevel.tr()),
                  )),
            ],
          ),
        ),
        actions: [
          Expanded(
              child: TextButton(
            child: Text(TextKeys.addAdmin.tr(), style: TextStyle(color: Colors.redAccent)),
            onPressed: () {
              if (_key.currentState!.validate()) {
                context.read<AdminsBloc>().add(AddAdmin(Admin(
                    name: name.value.text,
                    password: password.value.text,
                    level: int.parse(level.value.text))));
                Navigator.pop(context);
              }
            },
          )),
          Expanded(
              child: TextButton(
            child: Text(TextKeys.cancel.tr()),
            onPressed: () => Navigator.pop(context),
          )),
        ],
      ),
    );
  }
}
