import 'package:falconx/lib.dart';

abstract class FalconBlocState<WIDGET extends StatefulWidget, STATE,
    BLOC extends BlocBase<STATE>> extends FalconState<WIDGET> {
  FalconBlocState({super.status});

  FocusNode? get focusNode => FocusManager.instance.primaryFocus;

  BLOC get bloc => context.read<BLOC>();

  @protected
  @override
  @Deprecated('Please use buildDefault instead.')
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WidgetStatusNotifier>(
      create: (context) => widgetStatusNotifier,
      child: Consumer<WidgetStatusNotifier>(
        builder: (context, viewState, child) => BlocConsumer<BLOC, STATE>(
          bloc: bloc,
          listener: onListener,
          listenWhen: (previous, current) => true,
          buildWhen: buildWhen,
          builder: (context, state) => GestureDetector(
            onTap: clearFocus,
            child: WillPopScope(
              onWillPop: () => onWillPop(context, state),
              child: buildDefault(context, state),
            ),
          ),
        ),
      ),
    );
  }

  void onListener(BuildContext context, STATE state) {
    if (state is WidgetState && state.event != null) {
      onListenEvent(context, state.event!.event, state.event!.data);
    }

    onListenBlocState(context, state);
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

  bool buildWhen(STATE previous, STATE current) {
    if (current is WidgetState && current.event == null) {
      return current.build;
    } else if (current is WidgetState && current.event != null) {
      return false;
    } else {
      return true;
    }
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus;
  }
}
