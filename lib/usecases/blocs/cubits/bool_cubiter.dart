import 'package:falconx/falconx.dart';

class BoolCubiter<C extends BlocBase<bool>> extends StatefulWidget {
  const BoolCubiter(
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
  final BlocWidgetBuilder<bool> builder;
  final BlocWidgetListener<bool>? listener;
  final BlocWidgetEvent? event;
  final BlocWidgetException? exception;
  final BlocBuilderCondition<bool>? buildWhen;
  final BlocListenerCondition<bool>? listenWhen;

  @override
  State<BlocResourceConsumerX<C, bool>> createState() =>
      BlocConsumerStateX<C, bool>();
}
