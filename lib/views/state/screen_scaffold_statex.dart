import 'package:falconx/falconx.dart';

class _PageLoadingIndicatorNotifier extends ValueNotifier<bool> {
  _PageLoadingIndicatorNotifier() : super(false);
}

abstract class ScreenScaffoldStateX<T extends StatefulWidgetX>
    extends StateX<T> {
  final WidgetStateNotifier _screenState =
      WidgetStateNotifier(state: WidgetState.normal);

  WidgetState get state => _screenState.value;

  WidgetStateNotifier get screenState => _screenState;

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
              body: ValueListenableBuilder<WidgetState>(
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

  Widget buildMainContent(BuildContext context, WidgetState viewState) {
    switch (viewState) {
      case WidgetState.normal:
        return buildBody(context);
      case WidgetState.loading:
        return buildBodyLoading(context);
      case WidgetState.empty:
        return buildBodyEmpty(context);
      case WidgetState.disabled:
        return buildBodyDisabled(context);
      case WidgetState.error:
        return buildBodyError(context);
      case WidgetState.hovered:
         Log.w('Screen is not have hovered state.');
         return buildBody(context);
      case WidgetState.focused:
        Log.w('Screen is not have focused state.');
        return buildBody(context);
      case WidgetState.pressed:
        Log.w('Screen is not have pressed state.');
        return buildBody(context);
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

  void emitChangeScreenState(WidgetState state) {
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
    if (!context.canPop()) SystemNavigator.pop();
    return Future.value(true);
  }
}
