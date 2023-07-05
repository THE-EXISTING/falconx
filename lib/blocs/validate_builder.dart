import 'package:falconx/lib.dart';

typedef ValidateWidgetBuilder<S> = Widget Function(
    BuildContext context, bool valid, S state);

abstract class ValidatorBooleanCubit<S> extends Cubit<S?> {
  ValidatorBooleanCubit() : super(null);

  bool validate(S? data);

  void check(S? data) {
    emit(data);
  }
}

abstract class ValidatorCubit<INPUT, OUTPUT> extends Cubit<INPUT?> {
  ValidatorCubit() : super(null);

  OUTPUT validate(INPUT? data);

  void check(INPUT? data) {
    emit(data);
  }
}

class ValidateBuilder<B extends BlocBase<S>, S> extends StatefulWidget {
  const ValidateBuilder({
    Key? key,
    this.source,
    required this.builder,
  }) : super(key: key);

  final B? source;
  final ValidateWidgetBuilder<S> builder;

  @override
  State<ValidateBuilder<B, S>> createState() => _ValidateBuilderState<B, S>();
}

class _ValidateBuilderState<B extends BlocBase<S>, S>
    extends State<ValidateBuilder<B, S>> {
  late B _bloc;
  bool _currentValidate = false;

  @override
  void initState() {
    super.initState();
    _bloc = widget.source ?? context.read<B>();
  }

  @override
  void didUpdateWidget(ValidateBuilder<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.source ?? context.read<B>();
    final currentBloc = widget.source ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.source ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.source == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return BlocBuilder<B, S>(
      bloc: _bloc,
      builder: (context, state) =>
          widget.builder(context, _currentValidate, state),
      buildWhen: (previous, current) {
        final validateCubit = widget.source as ValidatorBooleanCubit;
        final validateResult = validateCubit.validate(current);
        if (validateResult != _currentValidate) {
          _currentValidate = validateResult;
          return true;
        } else {
          _currentValidate = validateResult;
          return false;
        }
      },
    );
  }
}
