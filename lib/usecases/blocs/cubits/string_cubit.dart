import 'package:falconx/falconx.dart';

class StringCubit extends Cubit<String>{

  StringCubit(String data) : super(data);

  String get data => state;

  void call(String string){
    emit(string);
  }
}