

part of'group_bloc.dart';


class GroupsEvent {}

class GetGroups extends GroupsEvent{}
class AddGroup extends GroupsEvent{Group group;
  File file;

AddGroup(this.group,this.file);
}
class DeleteGroup extends GroupsEvent{String id;

DeleteGroup(this.id);
}
class UpdateGroup extends GroupsEvent{Group group;
File? file;
UpdateGroup(this.group,this.file);
}