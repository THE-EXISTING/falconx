import 'package:falconx/falconx.dart';

class _PageLoadingIndicatorNotifier extends ValueNotifier<bool> {
  _PageLoadingIndicatorNotifier() : super(false);
}

abstract class ScreenScaffoldBlocStateX<T extends StatefulWidgetX,
    B extends BlocBase<S>, S> extends StateX<T> {
  B get bloc => context.read<B>();

  ScreenEventCubit? _screenEventCubit;

  FocusNode? get screenFocusNode => FocusManager.instance.primaryFocus;

  final _PageLoadingIndicatorNotifier _showPageLoadingIndicator =
      _PageLoadingIndicatorNotifier();

  @override
  void initState() {
    super.initState();
    if (bloc is BlocX) {
      _screenEventCubit = (bloc as BlocX).screenEventCubit;
    } else {
      Log.w('No use Blocx');
    }
  }

  Color get backgroundColor => Colors.white;

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    return buildRoot(context, _buildBloc(context));
  }

  void clearFocus() => FocusScope.of(context).unfocus();

  Widget buildRoot(BuildContext context, Widget blocListener) {
    return blocListener;
  }

  Widget _buildBloc(BuildContext context) {
    return BlocListener<ScreenEventCubit, BlocEvent?>(
      bloc: _screenEventCubit,
      listener: (context, BlocEvent? blocEvent) {
        if (blocEvent?.name == ScreenEvent.pop) {
          Navigator.pop(context, blocEvent?.data);
        } else if (blocEvent != null) {
          onListenEvent(context, blocEvent.name, blocEvent.data);
        }
      },
      child: BlocResourceConsumerX<B, S>(
        listener: onListenBloc,
        exception: onExceptionBloc,
        buildWhen: buildWhen,
        listenWhen: listenWhen,
        builder: (context, state) {
          return GestureDetector(
            onTap: clearFocus,
            child: WillPopScope(
              onWillPop: () => onWillPop(state),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                drawer: buildDrawer(context, state),
                bottomNavigationBar: buildBottomNavigation(context, state),
                backgroundColor: backgroundColor,
                appBar: buildAppBar(state),
                body: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    buildMainContent(context, state),
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMainContent(BuildContext context, S state) {
    Widget buildWidget;
    if (state is BlocState) {
      switch (state.status) {
        case BlocStatus.init:
          buildWidget = buildBodyEmpty(context, state);
          postBuild(context, state);
          return buildWidget;
        case BlocStatus.success:
          buildWidget = buildBody(context, state);
          postBuild(context, state);
          return buildWidget;
        case BlocStatus.loading:
          if(state.hasData()){
            buildWidget = buildBodyLoading(context, state);
          }else{
            buildWidget = buildBodyLoadingWithNoData(context, state);
          }
          postBuild(context, state);
          return buildWidget;
        case BlocStatus.error:
          buildWidget = buildBodyError(context, state);
          postBuild(context, state);
          return buildWidget;
      }
    }
    buildWidget = buildBody(context, state);
    postBuild(context, state);
    return buildWidget;
  }

  Widget buildBody(BuildContext context, S state);

  Widget buildBodyLoadingWithNoData(BuildContext context, S state) {
    return buildBody(context, state);
  }

  Widget buildBodyLoading(BuildContext context, S state) {
    return buildBody(context, state);
  }

  Widget buildBodyEmpty(BuildContext context, S state) {
    return buildBody(context, state);
  }

  Widget buildBodyDisabled(BuildContext context, S state) {
    return buildBody(context, state);
  }

  Widget buildBodyError(BuildContext context, S state) {
    return buildBody(context, state);
  }

  Widget buildPageLoadingIndicator() {
    return Space.boxZero;
  }

  Widget? buildDrawer(BuildContext context, S state) {
    return null;
  }

  Widget? buildBottomNavigation(BuildContext context, S state) {
    return null;
  }

  void postBuild(BuildContext context, S state) {}

  void onListenEvent(BuildContext context, Object event, Object? data) {}

  void onExceptionBloc(BuildContext context, exception) {}

  void onListenBloc(BuildContext context, S state) {}

  PreferredSizeWidget? buildAppBar(S state) {
    return null;
  }

  Future<bool> onWillPop(S state) {
    clearFocus();
    if (state is BlocState && state.status == BlocStatus.loading) {
      return Future.value(false);
    }
    return Future.value(true);
  }

  bool listenWhen(previous, current) {
    return true;
  }

  bool buildWhen(previous, current) {
    return true;
  }

  void showPageLoadingIndicatorFromResource(BlocState resource,
      {bool otherCondition = true}) {
    if (resource.isLoading() && otherCondition) {
      showPageLoadingIndicator();
    } else {
      hidePageLoadingIndicator();
    }
  }

  void showPageLoadingIndicator() {
    _showPageLoadingIndicator.value = true;
  }

  void hidePageLoadingIndicator() {
    _showPageLoadingIndicator.value = false;
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus;
  }
}
