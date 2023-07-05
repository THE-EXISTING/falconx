import 'package:falconx/lib.dart';

abstract class BehaviorBloc<EVENT, STATE> extends FalconBloc<EVENT, STATE> {
  BehaviorBloc(STATE initialState) : super(initialState);

  final _subject = BehaviorSubject<STATE>();

  @override
  Stream<STATE> get stream => _subject.stream;
}
