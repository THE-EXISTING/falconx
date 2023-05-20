import 'package:falconx/falconx.dart';

enum WidgetState {
  normal,
  disabled,
  loading,
  empty,
  error,
  hovered,
  focused,
  pressed,
}

class WidgetStateNotifier extends ValueNotifier<WidgetState> {
  WidgetStateNotifier({
    required WidgetState state,
  }) : super(state);

}