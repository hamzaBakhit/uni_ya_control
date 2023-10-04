import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/routes.dart';
import '../features/settings/logic/settings_bloc.dart';

class MaterialConfig extends StatefulWidget {
  const MaterialConfig({Key? key}) : super(key: key);

  @override
  State<MaterialConfig> createState() => _MaterialConfigState();
}

class _MaterialConfigState extends State<MaterialConfig> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(context.watch<SettingsBloc>().state.isLight
                ? 'assets/images/light_ground.png'
                : 'assets/images/dark_ground.jpg'),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        themeMode: context.watch<SettingsBloc>().state.isLight? ThemeMode.light:ThemeMode.dark,
        theme:ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        title: 'Uni Ya Control',
        initialRoute: Routes.initialRoute,
        routes: Routes().routes,
        color: Colors.transparent,
        builder: EasyLoading.init(),
      ),
    );
  }
}
