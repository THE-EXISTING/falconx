import 'package:falconx/lib.dart';

typedef ValidateWidgetBuilder<DATA> = Widget Function(
    BuildContext context, bool valid, DATA? data, Object? error);

abstract class ValidatorBooleanCubit<DATA> extends Cubit<ValidateState<DATA?>> {
  ValidatorBooleanCubit() : super(const ValidateState(data: null));

  bool onValidate(BuildContext context, DATA? data);

  void validate(DATA? data, {bool build = false}) {
    emit(ValidateState(data: data, build: build));
  }

  void emitError(DATA? data, {required Object? error}) {
    emit(ValidateState(data: data, error: error, build: true));
  }

  @Deprecated("Please use `validate` or `emitError`")
  @override
  void emit(ValidateState<DATA?> state) {
    super.emit(state);
  }
}

class ValidateBuilder<B extends Cubit<ValidateState<DATA?>>, DATA>
    extends StatefulWidget {
  const ValidateBuilder({
    Key? key,
    this.source,
    required this.builder,
  }) : super(key: key);

  final B? source;
  final ValidateWidgetBuilder<DATA> builder;

  @override
  State<ValidateBuilder<B, DATA>> createState() => _ValidateBuilderState<B, DATA>();
}

class _ValidateBuilderState<B extends Cubit<ValidateState<DATA?>>, DATA>
    extends State<ValidateBuilder<B, DATA>> {
  late B _bloc;
  bool _currentValidate = false;

  @override
  void initState() {
    super.initState();
    _bloc = widget.source ?? context.read<B>();
  }

  @override
  void didUpdateWidget(ValidateBuilder<B, DATA> oldWidget) {
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
    return BlocBuilder<B, ValidateState<DATA?>>(
      bloc: _bloc,
      builder: (context, state) =>
          widget.builder(context, _currentValidate, state.data, state.error),
      buildWhen: (previous, current) {
        final validateCubit = widget.source as ValidatorBooleanCubit;
        final validateResult = validateCubit.onValidate(context, current.data);
        if (validateResult != _currentValidate) {
          _currentValidate = validateResult;
          return true;
        } else {
          _currentValidate = validateResult;
          return current.build;
        }
      },
    );
  }
}