import 'package:falconx/falconx.dart';

abstract class WidgetStateX<T extends StatefulWidgetX> extends StateX<T> {
  WidgetStateX({WidgetDisplayState? viewState})
      : _stateNotifier =
  WidgetShowStateNotifier(state: viewState ?? WidgetDisplayState.normal);

  final WidgetShowStateNotifier _stateNotifier;

  WidgetDisplayState get viewState => _stateNotifier.value;

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WidgetShowStateNotifier>(
        create: (context) => _stateNotifier,
        child: Consumer<WidgetShowStateNotifier>( //
            builder: (context, viewState, child) {
              switch (viewState.value) {
                case WidgetDisplayState.normal:
                  if (viewState.value == WidgetDisplayState.loading) {
                    return buildLoading(context);
                  }
                  if (viewState.value == WidgetDisplayState.empty) {
                    return buildEmpty(context);
                  }
                  if (viewState.value == WidgetDisplayState.disabled) {
                    return buildDisabled(context);
                  }
                  if (viewState.value == WidgetDisplayState.error) {
                    return buildError(context);
                  }
                  return buildDefault(context);
                case WidgetDisplayState.loading:
                  return buildLoading(context);
                case WidgetDisplayState.empty:
                  return buildEmpty(context);
                case WidgetDisplayState.disabled:
                  return buildDisabled(context);
                case WidgetDisplayState.error:
                  return buildError(context);
              }
            }));
  }

  Widget buildDefault(BuildContext context);

  Widget buildLoading(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildEmpty(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildDisabled(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildError(BuildContext context) {
    return buildDefault(context);
  }

  void changeState(WidgetDisplayState state) {
    _stateNotifier.value = state;
  }

  void updateState() {
    setState(() { });
  }
}
