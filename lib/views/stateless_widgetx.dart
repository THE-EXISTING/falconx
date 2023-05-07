import 'package:falconx/falconx.dart';

abstract class StatelessWidgetX extends StatelessWidget {
  String get tag => runtimeType.toString();

  final WidgetDisplayState displayState;

  const StatelessWidgetX({
    Key? key,
    WidgetDisplayState? state,
  })  : displayState = state ?? WidgetDisplayState.normal,
        super(key: key);

  bool get isNormal => displayState == WidgetDisplayState.normal;

  bool get isNotNormal => !isNormal;

  bool get isLoading => displayState == WidgetDisplayState.loading;

  bool get isNotLoading => !isLoading;

  bool get isEmpty => displayState == WidgetDisplayState.empty;

  bool get isNotEmpty => !isEmpty;

  bool get isError => displayState == WidgetDisplayState.error;

  bool get isNotError => !isError;

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    switch (displayState) {
      case WidgetDisplayState.normal:
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

  void goToPath(
    BuildContext context,
    String path, {
    Object? extra,
  }) {
    return context.go(path, extra: extra);
  }

  void goToScreenNamed(
    BuildContext context,
    String screenName, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
  }) {
    return context.goNamed(
      screenName,
      params: params ?? const <String, String>{},
      queryParams: queryParams ?? const <String, dynamic>{},
    );
  }

  void popScreen(BuildContext context) {
    return context.pop();
  }
}
