import 'package:falconx/lib.dart';

typedef BlocWidgetListenerState<S> = void Function(
    BuildContext context, S state);
typedef BlocWidgetListenerEvent<S> = void Function(
    BuildContext context, S event, Object? data);
typedef CanPopListener<S> = bool Function(S state);
typedef PopListener<S> = void Function(S state);
@Deprecated(
  'Use PopListener instead. '
  'This feature was deprecated after v3.12.0-1.0.pre.',
)
typedef WillPopListener<S> = Future<bool> Function(
    BuildContext context, S state);

abstract class FalconBlocState<WIDGET extends StatefulWidget, STATE,
    BLOC extends BlocBase<STATE>> extends FalconState<WIDGET> {
  FalconBlocState({super.state});

  FocusNode? get focusNode => FocusManager.instance.primaryFocus;

  BLOC get bloc => context.read<BLOC>();

  Widget buildWithBloc<EVENT>({
    BlocWidgetListenerEvent<EVENT>? listenEvent,
    BlocWidgetListenerState<STATE>? listenState,
    CanPopListener<STATE>? canPop,
    PopListener<STATE>? onPop,
    @Deprecated(
      'Use onPop instead. '
      'This feature was deprecated after v3.12.0-1.0.pre.',
    )
    WillPopListener<STATE>? onWillPop,
    BlocListenerCondition<STATE>? buildWhen,
    required Widget Function(BuildContext context, STATE state) builder,
  }) =>
      BlocConsumer<BLOC, STATE>(
        bloc: bloc,
        listener: (BuildContext context, STATE state) {
          if (state is WidgetStateEvent && state.event != null) {
            listenEvent?.call(
                context, state.event!.name as EVENT, state.event!.data);
          }

          listenState?.call(context, state);
        },
        listenWhen: (previous, current) => true,
        buildWhen: (previous, current) {
          // Not build the widget when state have the event
          if (current is WidgetStateEvent && current.event != null) {
            return false;
          } else if (current is WidgetStateEvent && current.event == null) {
            return current.build;
          } else {
            return buildWhen?.call(previous, current) ?? true;
          }
        },
        builder: (context, state) => GestureDetector(
          onTap: clearFocus,
          child: _buildCompatPopScope<STATE>(
            state: state,
            canPop: canPop,
            onPop: onPop,
            onWillPop: onWillPop,
            child: builder(context, state),
          ),
        ),
      );

  Widget buildWithAnotherBloc<EVENT, S, B extends StateStreamable<S>>({
    required B bloc,
    BlocWidgetListenerEvent<EVENT>? listenEvent,
    BlocWidgetListenerState<S>? listenState,
    CanPopListener<S>? canPop,
    PopListener<S>? onPop,
    @Deprecated(
      'Use onPop instead. '
      'This feature was deprecated after v3.12.0-1.0.pre.',
    )
    WillPopListener<S>? onWillPop,
    BlocListenerCondition<S>? buildWhen,
    required Widget Function(BuildContext context, S state) builder,
  }) =>
      BlocConsumer<B, S>(
        bloc: bloc,
        listener: (BuildContext context, S state) {
          if (state is WidgetStateEvent && state.event != null) {
            listenEvent?.call(
                context, state.event!.name as EVENT, state.event!.data);
          }

          listenState?.call(context, state);
        },
        listenWhen: (previous, current) => true,
        buildWhen: (previous, current) {
          // Not build the widget when state have the event
          if (current is WidgetStateEvent && current.event != null) {
            return false;
          } else if (current is WidgetStateEvent && current.event == null) {
            return current.build;
          } else {
            return buildWhen?.call(previous, current) ?? true;
          }
        },
        builder: (context, state) => GestureDetector(
          onTap: clearFocus,
          child: _buildCompatPopScope<S>(
            state: state,
            canPop: canPop,
            onPop: onPop,
            onWillPop: onWillPop,
            child: builder(context, state),
          ),
        ),
      );

  Widget _buildCompatPopScope<S>({
    required S state,
    required CanPopListener<S>? canPop,
    required PopListener<S>? onPop,
    required WillPopListener<S>? onWillPop,
    required Widget child,
  }) =>
      onPop != null || canPop != null
          ? PopScope(
              canPop: canPop?.call(state) ?? true,
              onPopInvoked: (didPop) {
                if (didPop) return;
                clearFocus();
                onPop?.call(state);
                if (!context.canPop()) SystemNavigator.pop();
              },
              child: child,
            )
          : onWillPop != null
              ? WillPopScope(
                  onWillPop: () {
                    clearFocus();
                    if (!context.canPop()) SystemNavigator.pop();
                    return onWillPop.call(context, state);
                  },
                  child: child,
                )
              : child;
}
