import 'package:falconx/lib.dart';

abstract class PublishBloc<EVENT, STATE> extends FalconBloc<EVENT, STATE> {
  PublishBloc(STATE initialState) : super(initialState);

  final _subject = PublishSubject<STATE>();

  @override
  Stream<STATE> get stream => _subject.stream;
}
