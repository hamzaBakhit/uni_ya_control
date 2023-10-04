part of'group_bloc.dart';

class GroupsState extends Equatable{
  List<Group> groups;

  GroupsState(this.groups);

  @override
  List<Object?> get props => [groups];

}

class GroupsShow extends GroupsState{
  GroupsShow(super.groups);
}
class GroupsProcess extends GroupsState{
  GroupsProcess(super.groups);
}

