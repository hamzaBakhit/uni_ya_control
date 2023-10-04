import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/remote/addition_remote_service.dart';
import '../../../services/remote/storage_remote_service.dart';
import '../model/addition.dart';

part 'addition_event.dart';

part 'addition_state.dart';

class AdditionsBloc extends Bloc<AdditionsEvent, AdditionsState> {
  AdditionsBloc() : super(AdditionsProcess(const [])) {
    on<GetAdditions>(_get);
    on<DeleteAddition>(_delete);
    on<AddAddition>(_add);
    on<UpdateAddition>(_update);
    add(GetAdditions());
  }

  _get(GetAdditions event, Emitter<AdditionsState> emit) async {
    emit(AdditionsProcess(state.additions));
    List<Addition> additions = [];
    additions = await AdditionsRemoteService.get().getAdditions();
    if (additions.isEmpty) {
      emit(AdditionsShow(state.additions));
    } else {
      emit(AdditionsShow(additions));
    }
  }

  _add(AddAddition event, Emitter<AdditionsState> emit) async {
    emit(AdditionsProcess(state.additions));
    List<Addition> additions =[];
    additions= state.additions;
    String img = await StorageService.get.addImage(
        id: event.addition.id, type: StorageType.addition, file: event.file);
    if (img.isNotEmpty) {
      event.addition.setImg(img);
      bool isDone =
          await AdditionsRemoteService.get().addAddition(event.addition);
      if (isDone) {
        additions.add(event.addition);
      } else {
        await StorageService.get
            .deleteImage(id: event.addition.id, type: StorageType.addition);
      }
    }
    emit(AdditionsShow(additions));
  }

  _delete(DeleteAddition event, Emitter<AdditionsState> emit) async {
    emit(AdditionsProcess(state.additions));
    List<Addition> additions = state.additions;
    Addition addition =
        additions.singleWhere((element) => element.id == event.id);
    additions.remove(addition);
    emit(AdditionsShow(additions));
    emit(AdditionsProcess(state.additions));
    bool isDone = await AdditionsRemoteService.get().deleteAddition(event.id);
    if (!isDone) {
      additions.add(addition);
    } else {
      await StorageService.get
          .deleteImage(id: event.id, type: StorageType.addition);
    }
    emit(AdditionsShow(additions));
  }

  _update(UpdateAddition event, Emitter<AdditionsState> emit) async {
    emit(AdditionsProcess(state.additions));
    List<Addition> additions = state.additions;
    if (event.file != null) {
      String img = await StorageService.get.addImage(
          id: event.addition.id, type: StorageType.addition, file: event.file!);
      if (img.isEmpty) {
        emit(AdditionsShow(additions));
        return;
      }
    }
    bool isDone =
        await AdditionsRemoteService.get().updateAddition(event.addition);
    if (isDone) {
      additions.removeWhere((element) => element.id == event.addition.id);
      additions.add(event.addition);
    }
    emit(AdditionsShow(additions));
  }

  List<Addition> getAdditions(List<String>? ids){
    if(ids==null){return state.additions;}else{
      return state.additions.where((element) => ids.contains(element.id)).toList();
    }
  }
}
