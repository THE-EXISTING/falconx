import 'package:falconx/falconx.dart';

abstract class WidgetBlocStateX<T extends StatefulWidgetX,
    B extends BlocBase<S>, S> extends StateX<T> {
  WidgetBlocStateX({WidgetDisplayState? viewState})
      : _stateNotifier = WidgetDisplayStateNotifier(
            state: viewState ?? WidgetDisplayState.normal);

  final WidgetDisplayStateNotifier _stateNotifier;
  NavigationEventCubit? _navigationEventCubit;

  B get bloc => context.read<B>();

  WidgetDisplayState get viewState => _stateNotifier.value;

  @override
  void initState() {
    super.initState();
    if (bloc is BlocX) {
      _navigationEventCubit = (bloc as BlocX).navigationEventCubit;
    } else {
      Log.w('No use Blocx');
    }
  }

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    return BlocListener<NavigationEventCubit, BlocEvent?>(
      bloc: _navigationEventCubit,
      listener: (context, BlocEvent? blocEvent) {
        if (blocEvent?.name == NavigationEvent.pop) {
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
          return ChangeNotifierProvider<WidgetDisplayStateNotifier>(
              create: (context) => _stateNotifier,
              child: Consumer<WidgetDisplayStateNotifier>(//
                  builder: (context, viewState, child) {
                switch (viewState.value) {
                  case WidgetDisplayState.normal:
                    if (viewState.value == WidgetDisplayState.loading) {
                      return buildLoading(context, state);
                    }
                    if (viewState.value == WidgetDisplayState.empty) {
                      return buildEmpty(context, state);
                    }
                    if (viewState.value == WidgetDisplayState.disabled) {
                      return buildDisabled(context, state);
                    }
                    if (viewState.value == WidgetDisplayState.error) {
                      return buildError(context, state);
                    }
                    return buildDefault(context, state);
                  case WidgetDisplayState.loading:
                    return buildLoading(context, state);
                  case WidgetDisplayState.empty:
                    return buildEmpty(context, state);
                  case WidgetDisplayState.disabled:
                    return buildDisabled(context, state);
                  case WidgetDisplayState.error:
                    return buildError(context, state);
                }
              }));
        },
      ),
    );
  }

  void onListenEvent(BuildContext context, Object event, Object? data) {}

  void onExceptionBloc(BuildContext context, exception) {}

  void onListenBloc(BuildContext context, S state) {}

  bool listenWhen(previous, current) {
    return true;
  }

  bool buildWhen(previous, current) {
    return true;
  }

  Widget buildDefault(BuildContext context, S state);

  Widget buildLoading(BuildContext context, S state) {
    return buildDefault(context, state);
  }

  Widget buildEmpty(BuildContext context, S state) {
    return buildDefault(context, state);
  }

  Widget buildDisabled(BuildContext context, S state) {
    return buildDefault(context, state);
  }

  Widget buildError(BuildContext context, S state) {
    return buildDefault(context, state);
  }

  void changeState(WidgetDisplayState state) {
    _stateNotifier.value = state;
  }

  void updateState() {
    setState(() {});
  }
}
