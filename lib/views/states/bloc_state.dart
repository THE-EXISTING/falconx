import 'package:falconx/lib.dart';

typedef BlocWidgetListenerState<S> = void Function(
    BuildContext context, S state);
typedef BlocWidgetListenerEvent<S> = void Function(
    BuildContext context, S event, Object? data);
typedef WillPopListener<S> = Future<bool> Function(
    BuildContext context, S state);

abstract class FalconBlocState<WIDGET extends StatefulWidget, STATE,
    BLOC extends BlocBase<STATE>> extends FalconState<WIDGET> {
  FalconBlocState({super.status});

  FocusNode? get focusNode => FocusManager.instance.primaryFocus;

  BLOC get bloc => context.read<BLOC>();

  Widget buildWithBloc<EVENT>({
    BlocWidgetListenerEvent<EVENT>? listenEvent,
    BlocWidgetListenerState<STATE>? listenState,
    WillPopListener<STATE>? onWillPop,
    BlocListenerCondition<STATE>? buildWhen,
    required Widget Function(BuildContext context, STATE state) builder,
  }) {
    return ChangeNotifierProvider<WidgetStatusNotifier>(
      create: (context) => widgetStatusNotifier,
      child: Consumer<WidgetStatusNotifier>(
        builder: (context, viewState, child) => BlocConsumer<BLOC, STATE>(
          bloc: bloc,
          listener: (BuildContext context, STATE state) {
            if (state is WidgetEventState && state.event != null) {
              listenEvent?.call(context, state.event!.name as EVENT, state.event!.data);
            }

            listenState?.call(context, state);
          },
          listenWhen: (previous, current) => true,
          buildWhen: (previous, current) {
            if (current is WidgetEventState && current.event != null) {
              return false;
            } else if (current is WidgetEventState && current.event == null) {
              // No event in current state
              return current.build;
            } else {
              return buildWhen?.call(previous, current) ?? true;
            }
          },
          builder: (context, state) => GestureDetector(
            onTap: clearFocus,
            child: WillPopScope(
              onWillPop: () {
                clearFocus();
                if (!context.canPop()) SystemNavigator.pop();
                return onWillPop?.call(context, state) ?? Future.value(true);
              },
              child: builder(context, state),
            ),
          ),
        ),
      ),
    );
  }
}
