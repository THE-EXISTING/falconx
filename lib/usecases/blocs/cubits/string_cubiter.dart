import 'package:falconx/falconx.dart';

class StringCubiter<C extends BlocBase<String>> extends StatefulWidget {
  const StringCubiter(
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
  final BlocWidgetBuilder<String> builder;
  final BlocWidgetListener<String>? listener;
  final BlocWidgetEvent? event;
  final BlocWidgetException? exception;
  final BlocBuilderCondition<String>? buildWhen;
  final BlocListenerCondition<String>? listenWhen;

  @override
  State<BlocResourceConsumerX<C, String>> createState() =>
      BlocConsumerStateX<C, String>();
}
