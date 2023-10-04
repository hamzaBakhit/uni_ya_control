part of'addition_bloc.dart';

class AdditionsState extends Equatable{
  List<Addition> additions;

  AdditionsState(this.additions);

  @override
  List<Object?> get props => [additions];

}

class AdditionsShow extends AdditionsState{
  AdditionsShow(super.additions);
}
class AdditionsProcess extends AdditionsState{
  AdditionsProcess(super.additions);
}

