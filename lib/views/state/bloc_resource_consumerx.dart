import 'package:falconx/falconx.dart';

typedef BlocWidgetException = void Function(
    BuildContext context, Object exception);
typedef BlocWidgetEvent<S> = void Function(S event);

class BlocResourceConsumerX<B extends BlocBase<S>, S> extends StatefulWidget {
  const BlocResourceConsumerX({
    Key? key,
    this.listener,
    this.exception,
    required this.builder,
    this.bloc,
    this.buildWhen,
    this.listenWhen,
  }) : super(key: key);

  final B? bloc;
  final BlocWidgetBuilder<S> builder;
  final BlocWidgetListener<S>? listener;
  final BlocWidgetException? exception;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;

  @override
  State<BlocResourceConsumerX<B, S>> createState() =>
      BlocConsumerStateX<B, S>();
}

class BlocConsumerStateX<B extends BlocBase<S>, S>
    extends State<BlocResourceConsumerX<B, S>> {
  late B bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc ?? context.read<B>();
  }

  @override
  void didUpdateWidget(BlocResourceConsumerX<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) bloc = currentBloc;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (this.bloc != bloc) this.bloc = bloc;
  }

  void handlerException(BuildContext context, Object exception) {}

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) context.select<B, int>(identityHashCode);
    return BlocBuilder<B, S>(
      bloc: bloc,
      builder: widget.builder,
      buildWhen: (previous, current) {
        if (widget.listenWhen?.call(previous, current) ?? true) {
          if (current is BlocState && current.isFail) {
            final Object? exception = current.error;
            if (exception != null) {
              handlerException(context, exception);
              widget.exception?.call(context, exception);
            }
          } else {
            widget.listener?.call(context, current);
          }
        }
        return widget.buildWhen?.call(previous, current) ?? true;
      },
    );
  }
}
