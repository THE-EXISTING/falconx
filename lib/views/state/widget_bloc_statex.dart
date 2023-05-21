import 'package:falconx/falconx.dart';

abstract class WidgetBlocStateX<T extends StatefulWidgetX,
    B extends BlocBase<S>, S> extends StateX<T> {
  WidgetBlocStateX({WidgetState? viewState})
      : _stateNotifier =
            WidgetStateNotifier(state: viewState ?? WidgetState.normal);

  final WidgetStateNotifier _stateNotifier;
  WidgetEventCubit? _widgetEventCubit;

  B get bloc => context.read<B>();

  WidgetState get viewState => _stateNotifier.value;

  @override
  void initState() {
    super.initState();
    if (bloc is BlocX) {
      _widgetEventCubit = (bloc as BlocX).widgetEventCubit;
    } else {
      Log.w('No use Blocx');
    }
  }

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    return BlocListener<WidgetEventCubit, BlocEvent?>(
      bloc: _widgetEventCubit,
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
        builder: (context, blocState) {
          return ChangeNotifierProvider<WidgetStateNotifier>(
              create: (context) => _stateNotifier,
              child: Consumer<WidgetStateNotifier>(//
                  builder: (context, viewState, child) {
                switch (viewState.value) {
                  case WidgetState.normal:
                    if (viewState.value == WidgetState.loading) {
                      return buildLoading(context,blocState, viewState.value);
                    }
                    if (viewState.value == WidgetState.empty) {
                      return buildEmpty(context,blocState, viewState.value);
                    }
                    if (viewState.value == WidgetState.disabled) {
                      return buildDisabled(context,blocState, viewState.value);
                    }
                    if (viewState.value == WidgetState.error) {
                      return buildError(context,blocState, viewState.value);
                    }
                    if (viewState.value == WidgetState.hovered) {
                      return buildHovered(context,blocState, viewState.value);
                    }
                    if (viewState.value == WidgetState.focused) {
                      return buildFocused(context,blocState, viewState.value);
                    }
                    if (viewState.value == WidgetState.pressed) {
                      return buildPressed(context,blocState, viewState.value);
                    }
                    return buildDefault(context,blocState, viewState.value);
                  case WidgetState.loading:
                    return buildLoading(context,blocState, viewState.value);
                  case WidgetState.empty:
                    return buildEmpty(context,blocState, viewState.value);
                  case WidgetState.disabled:
                    return buildDisabled(context,blocState, viewState.value);
                  case WidgetState.error:
                    return buildError(context,blocState, viewState.value);
                  case WidgetState.hovered:
                    return buildHovered(context,blocState, viewState.value);
                  case WidgetState.focused:
                    return buildFocused(context,blocState, viewState.value);
                  case WidgetState.pressed:
                    return buildPressed(context,blocState, viewState.value);
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

  Widget buildDefault(BuildContext context, S blocState, WidgetState viewState);

  Widget buildLoading(BuildContext context, S blocState, WidgetState viewState) {
    return buildDefault(context, blocState, viewState);
  }

  Widget buildEmpty(BuildContext context, S blocState, WidgetState viewState) {
    return buildDefault(context, blocState, viewState);
  }

  Widget buildDisabled(BuildContext context, S blocState, WidgetState viewState) {
    return buildDefault(context, blocState, viewState);
  }

  Widget buildError(BuildContext context, S blocState, WidgetState viewState) {
    return buildDefault(context, blocState, viewState);
  }

  Widget buildHovered(BuildContext context, S blocState, WidgetState viewState) {
    return buildDefault(context, blocState, viewState);
  }

  Widget buildFocused(BuildContext context, S blocState, WidgetState viewState) {
    return buildDefault(context, blocState, viewState);
  }

  Widget buildPressed(BuildContext context, S blocState, WidgetState viewState) {
    return buildDefault(context, blocState, viewState);
  }

  void changeState(WidgetState state) {
    _stateNotifier.value = state;
  }

  void updateState() {
    setState(() {});
  }
}
