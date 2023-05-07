import 'package:falconx/falconx.dart';

class IntCubit extends Cubit<int>{

  IntCubit(int data) : super(data);

  int get data => state;

  void call(int integer){
    emit(integer);
  }

  void increment([int increase = 1]) => emit(state + increase);
  void decrement([int decrease = 1]) => emit(state - decrease);
}