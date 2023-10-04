import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya_control/features/admin/logic/admins_bloc.dart';
import 'package:uni_ya_control/services/remote/notifications.dart';

import '../../../../constants/routes.dart';
import '../../../../constants/texts.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isPasswordShow = false, isRememberMe = true;
  TextEditingController nameController = TextEditingController(),
      passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/log_in_background.jpg'),
              fit: BoxFit.fill),
        ),
        child: BlocBuilder<AdminsBloc,AdminsState>(
          builder: (context,state) {
            EasyLoading.instance
              ..displayDuration = const Duration(milliseconds: 2000)
              ..indicatorType = EasyLoadingIndicatorType.wave
              ..loadingStyle = EasyLoadingStyle.dark
              ..indicatorSize = 45.0
              ..radius = 10.0
              ..progressColor = Colors.yellow
              ..backgroundColor = Colors.green
              ..indicatorColor = Colors.yellow
              ..textColor = Colors.yellow
              ..maskColor = Colors.blue.withOpacity(0.5)
              ..userInteractions = true
              ..dismissOnTap = false;

            if (state is AdminsProcess) {
              EasyLoading.show();
            }
            else if (state is AdminsShow) {
              EasyLoading.showSuccess('Hi, ${state.myAdmin.name}',
                  duration: const Duration(milliseconds: 500))
                  .then((value) => Navigator.pushNamedAndRemoveUntil(
                  context, Routes.mainOrders, (route) => false));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.30),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 2, color: Colors.white30)),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    TextKeys.logIn.tr(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    TextKeys.welcomeInLogIn.tr(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return TextKeys.emptyName.tr();
                                      }
                                      return null;
                                    },
                                    controller: nameController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        TextKeys.userName.tr(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      suffixIcon:
                                          Icon(Icons.person, color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return TextKeys.emptyPassword.tr();
                                      }
                                    },
                                    controller: passwordController,
                                    obscureText: !isPasswordShow,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        TextKeys.password.tr(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () => setState(() {
                                                isPasswordShow = !isPasswordShow;
                                              }),
                                          icon: Icon(
                                              isPasswordShow
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Checkbox(
                                          activeColor: Colors.black,
                                          value: isRememberMe,
                                          onChanged: (value) => setState(() {
                                                isRememberMe = value!;
                                              })),
                                      Text(TextKeys.rememberMe.tr()),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                       context.read<AdminsBloc>().add(LogInAdmin(name: nameController.value.text.trim(), password: passwordController.value.text, remember: isRememberMe)) ;
                                      }
                                    },
                                    child: Text(TextKeys.logIn.tr()),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Colors.black),
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
