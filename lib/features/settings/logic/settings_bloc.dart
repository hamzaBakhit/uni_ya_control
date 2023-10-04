import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/local/local_service.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(isLight: true, isNotification: true)) {
    _getStoredSettings();
    on<ChangeSettingsIsLight>(_changeIsLight);
    on<ChangeSettingsNotification>(_changeNotification);
  }

  _getStoredSettings()async {
    Map<String,dynamic> map=await LocalService.get.getSettings();
    emit(SettingsState(isLight: map['isLight'], isNotification: map['isNotification']));
  }

  _changeIsLight(ChangeSettingsIsLight event, Emitter<SettingsState> emit) {
    LocalService.get.setLocalData({
      'isLight':event.isLight
    });
    emit(SettingsState(
        isLight: event.isLight, isNotification: state.isNotification));
  }

  _changeNotification(
      ChangeSettingsNotification event, Emitter<SettingsState> emit) {
    LocalService.get.setLocalData({
      'isNotification':event.isWork
    });
    emit(SettingsState(isLight: state.isLight, isNotification: event.isWork));
  }
}
