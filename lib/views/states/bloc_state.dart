import 'package:falconx/lib.dart';

abstract class FalconBlocState<WIDGET extends StatefulWidget, STATE,
    BLOC extends BlocBase<STATE>> extends FalconState<WIDGET> {
  FocusNode? get focusNode => FocusManager.instance.primaryFocus;

  BLOC get bloc => context.read<BLOC>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BLOC, STATE>(
        bloc: bloc,
        listener: onListenBloc,
        buildWhen: buildWhen,
        listenWhen: listenWhen,
        builder: (context, state) {
          return GestureDetector(
            onTap: clearFocus,
            child: WillPopScope(
              onWillPop: () => onWillPop(context, state),
              child: buildDefault(context, state),
            ),
          );
        });
  }

  void clearFocus() => FocusScope.of(context).unfocus();

  Widget buildDefault(BuildContext context, STATE state);

  void onListenEvent(BuildContext context, Object event, Object? data) {}

  void onListenBloc(BuildContext context, STATE state) {}

  Future<bool> onWillPop(BuildContext context, STATE state) {
    clearFocus();
    if (!context.canPop()) SystemNavigator.pop();
    return Future.value(true);
  }

  bool listenWhen(STATE previous, STATE current) {
    return current is WidgetEvent;
  }

  bool buildWhen(STATE previous, STATE current) {
    return current is! WidgetEvent;
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus;
  }
}
