import 'package:falconx/falconx.dart';

class BoolCubit extends Cubit<bool>{

  BoolCubit(bool data) : super(data);

  bool get data => state;

  void call(bool boolean){
    emit(boolean);
  }

  void toggle(){
    emit(!state);
  }
}