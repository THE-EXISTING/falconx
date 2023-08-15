import 'package:falconx/lib.dart';

typedef ValidateWidgetBuilder<DATA> = Widget Function(
    BuildContext context, bool valid, DATA? data, Failure? failure);

abstract class ValidatorCubit<DATA> extends Cubit<ValidateState<DATA?>> {
  ValidatorCubit() : super(const ValidateState(data: null));

  Failure? onValidate(DATA? data);

  bool get isValid => onValidate(state.data) == null;

  bool get isInvalid => !isValid;

  Failure? validate(DATA? data, {bool canBuild = false}) {
    final failure = onValidate(data);
    emit(ValidateState(data: data, failure: failure, canBuild: canBuild));
    return failure;
  }

  void clear() {
    emit(const ValidateState(data: null));
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
  State<ValidateBuilder<B, DATA>> createState() =>
      _ValidateBuilderState<B, DATA>();
}

class _ValidateBuilderState<B extends Cubit<ValidateState<DATA?>>, DATA>
    extends State<ValidateBuilder<B, DATA>> {
  late B _bloc;
  bool _currentValid = false;

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
      buildWhen: (previous, current) {
        final valid = current.failure == null;
        if (previous.failure != current.failure) {
          _currentValid = valid;
          return true;
        } else {
          _currentValid = valid;
          return current.canBuild;
        }
      },
      builder: (context, state) =>
          widget.builder(context, _currentValid, state.data, state.failure),
    );
  }
}
