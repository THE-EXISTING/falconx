import 'package:falconx/lib.dart';

class ValidateState<DATA>{
  final DATA? data;
  final Object? error;
  final bool build;

  const ValidateState({
    this.data,
    this.error,
    this.build = false,
  });

  ValidateState<DATA> copyWith({
    DATA? data,
    Object? error,
    bool? build,
  }) {
    return ValidateState(
      data: data ?? this.data,
      error: error ?? this.error,
      build: build ?? this.build,
    );
  }

  @override
  String toString() {
    return 'ValidatorState{data: $data, error: $error, build: $build}';
  }
}