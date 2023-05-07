import 'package:falconx/falconx.dart';

class _PageLoadingIndicatorNotifier extends ValueNotifier<bool> {
  _PageLoadingIndicatorNotifier() : super(false);
}

abstract class ScreenScaffoldStateX<T extends StatefulWidgetX>
    extends StateX<T> {
  final WidgetShowStateNotifier _screenState =
      WidgetShowStateNotifier(state: WidgetDisplayState.normal);

  WidgetDisplayState get state => _screenState.value;

  WidgetShowStateNotifier get screenState => _screenState;

  final _PageLoadingIndicatorNotifier _showPageLoadingIndicator =
      _PageLoadingIndicatorNotifier();

  Color get backGroundColor => Colors.white;

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    return buildRoot(
        context,
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: WillPopScope(
            onWillPop: () => onWillPop(context),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: backGroundColor,
              drawer: buildDrawer(context),
              appBar: buildAppBar(context),
              bottomNavigationBar: buildBottomNavigation(context),
              body: ValueListenableBuilder<WidgetDisplayState>(
                  valueListenable: screenState,
                  builder: (context, viewState, child) {
                    return Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        buildMainContent(context, viewState),
                        ValueListenableBuilder<bool>(
                          valueListenable: _showPageLoadingIndicator,
                          builder: (context, show, child) {
                            if (show) {
                              return buildPageLoadingIndicator();
                            } else {
                              return Space.boxZero;
                            }
                          },
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ));
  }

  void clearFocus() => FocusManager.instance.primaryFocus?.unfocus();

  Widget buildRoot(BuildContext context, Widget parent) {
    return parent;
  }

  Widget buildMainContent(BuildContext context, WidgetDisplayState viewState) {
    switch (viewState) {
      case WidgetDisplayState.normal:
        return buildBody(context);
      case WidgetDisplayState.loading:
        return buildBodyLoading(context);
      case WidgetDisplayState.empty:
        return buildBodyEmpty(context);
      case WidgetDisplayState.disabled:
        return buildBodyDisabled(context);
      case WidgetDisplayState.error:
        return buildBodyError(context);
    }
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus;
  }

  Widget buildBody(BuildContext context);

  Widget buildBodyLoading(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBodyEmpty(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBodyDisabled(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBodyError(BuildContext context) {
    return buildBody(context);
  }

  Widget buildPageLoadingIndicator() {
    return Space.boxZero;
  }

  void emitChangeScreenState(WidgetDisplayState state) {
    _screenState.value = state;
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  Widget? buildDrawer(BuildContext context) {
    return null;
  }

  Widget? buildBottomNavigation(BuildContext context) {
    return null;
  }

  Future<bool> onWillPop(BuildContext context) {
    clearFocus();
    return Future.value(true);
  }
}
