part of'settings_bloc.dart';

 class SettingsState extends Equatable{
  bool isLight;
  bool isNotification;

  SettingsState({required this.isLight,required this.isNotification});

  @override
  List<Object?> get props => [isLight,isNotification];
}

