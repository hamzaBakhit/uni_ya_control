import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/config.dart';

class MyDrawerCubit extends Cubit<bool> {
  MyDrawerCubit() : super(false);
  final ZoomDrawerController controller = ZoomDrawerController();

  toggle() {
    controller.toggle!.call();
    emit(!state);
  }
}
