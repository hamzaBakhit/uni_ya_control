

part of'addition_bloc.dart';


class AdditionsEvent {}

class GetAdditions extends AdditionsEvent{}
class AddAddition extends AdditionsEvent{Addition addition;
  File file;

AddAddition(this.addition,this.file);
}
class DeleteAddition extends AdditionsEvent{String id;

DeleteAddition(this.id);
}
class UpdateAddition extends AdditionsEvent{Addition addition;
File? file;
UpdateAddition(this.addition,this.file);
}