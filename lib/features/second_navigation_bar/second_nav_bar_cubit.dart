

import 'package:flutter_bloc/flutter_bloc.dart';

class SecondNavBarCubit extends Cubit<int>{
  SecondNavBarCubit():super(0);
  changePage(int index){
    emit(index);
  }
}