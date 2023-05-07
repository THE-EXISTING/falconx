import 'package:falconx/falconx.dart';

abstract class StatefulWidgetX extends StatefulWidget {
  String get tag => runtimeType.toString();

  bool get isLog => false;


  const StatefulWidgetX({Key? key}) : super(key: key);
}
