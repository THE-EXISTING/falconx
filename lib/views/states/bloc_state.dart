import 'package:falconx/lib.dart';

abstract class FalconBlocState<WIDGET extends StatefulWidget, STATE,
    BLOC extends BlocBase<STATE>> extends FalconState<WIDGET> {
  FocusNode? get focusNode => FocusManager.instance.primaryFocus;

  BLOC get bloc => context.read<BLOC>();

  @protected
  @override
  @Deprecated('Please use buildDefault instead.')
  Widget build(BuildContext context) {
    return BlocConsumer<BLOC, STATE>(
        bloc: bloc,
        listener: onListener,
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

  void onListener(BuildContext context, STATE state) {
    if (state is WidgetEvent) {
      onListenEvent(context, state.name, state.data);
    } else {
      onListenBlocState(context, state);
    }
  }

  void clearFocus() => FocusScope.of(context).unfocus();

  Widget buildDefault(BuildContext context, STATE state);

  void onListenEvent(BuildContext context, Object event, Object? data) {}

  void onListenBlocState(BuildContext context, STATE state) {}

  Future<bool> onWillPop(BuildContext context, STATE state) {
    clearFocus();
    if (!context.canPop()) SystemNavigator.pop();
    return Future.value(true);
  }

  bool listenWhen(STATE previous, STATE current) {
    return true;
  }

  bool buildWhen(STATE previous, STATE current) {
    return current is! WidgetEvent;
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus;
  }
}
