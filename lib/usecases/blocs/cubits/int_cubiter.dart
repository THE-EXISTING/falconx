import 'package:falconx/falconx.dart';

class IntCubiter<C extends BlocBase<int>> extends StatefulWidget {
  const IntCubiter(
      this.builder, {
        Key? key,
        this.listener,
        this.exception,
        this.event,
        this.cubit,
        this.buildWhen,
        this.listenWhen,
      }) : super(key: key);

  final C? cubit;
  final BlocWidgetBuilder<int> builder;
  final BlocWidgetListener<int>? listener;
  final BlocWidgetEvent? event;
  final BlocWidgetException? exception;
  final BlocBuilderCondition<int>? buildWhen;
  final BlocListenerCondition<int>? listenWhen;

  @override
  State<BlocResourceConsumerX<C, int>> createState() =>
      BlocConsumerStateX<C, int>();
}
