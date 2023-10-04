import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/remote/groups_remote_service.dart';
import '../../../services/remote/storage_remote_service.dart';
import '../model/group.dart';

part 'group_event.dart';

part 'group_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc() : super(GroupsProcess(const [])) {
    on<GetGroups>(_get);
    on<DeleteGroup>(_delete);
    on<AddGroup>(_add);
    on<UpdateGroup>(_update);
    add(GetGroups());
  }

  _get(GetGroups event, Emitter<GroupsState> emit) async {
    emit(GroupsProcess(state.groups));
    List<Group> groups = [];
    groups = await GroupsRemoteService.get().getGroups();
    if (groups.isEmpty) {
      emit(GroupsShow(state.groups));
    } else {
      emit(GroupsShow(groups));
    }
  }

  _add(AddGroup event, Emitter<GroupsState> emit) async {
    emit(GroupsProcess(state.groups));
    List<Group> groups = [];
    groups = state.groups;
    String img = await StorageService.get.addImage(
        id: event.group.id, type: StorageType.group, file: event.file);
    if (img.isNotEmpty) {
      event.group.setImg(img);
      bool isDone = await GroupsRemoteService.get().addGroup(event.group);
      if (isDone) {
        groups.add(event.group);
      } else {
        await StorageService.get
            .deleteImage(id: event.group.id, type: StorageType.group);
      }
    }
    emit(GroupsShow(groups));
  }

  _delete(DeleteGroup event, Emitter<GroupsState> emit) async {
    emit(GroupsProcess(state.groups));
    List<Group> groups = state.groups;
    Group group = groups.singleWhere((element) => element.id == event.id);
    groups.remove(group);
    emit(GroupsShow(groups));
    emit(GroupsProcess(state.groups));
    bool isDone = await GroupsRemoteService.get().deleteGroup(event.id);
    if (!isDone) {
      groups.add(group);
    } else {
      await StorageService.get
          .deleteImage(id: event.id, type: StorageType.group);
    }
    emit(GroupsShow(groups));
  }

  _update(UpdateGroup event, Emitter<GroupsState> emit) async {
    emit(GroupsProcess(state.groups));
    List<Group> groups = state.groups;
    if (event.file != null) {
      String img = await StorageService.get.addImage(
          id: event.group.id, type: StorageType.group, file: event.file!);
      if (img.isEmpty) {
        emit(GroupsShow(groups));
        return;
      }
    }
    bool isDone = await GroupsRemoteService.get().updateGroup(event.group);
    if (isDone) {
      groups.removeWhere((element) => element.id == event.group.id);
      groups.add(event.group);
    }
    emit(GroupsShow(groups));
  }

  List<Group> getGroups(List<String>? ids){
    if(ids==null){return state.groups;}else{
      return state.groups.where((element) => ids.contains(element.id)).toList();
    }
  }

}
