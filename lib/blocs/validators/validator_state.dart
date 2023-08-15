import 'package:falconx/lib.dart';

class ValidatorState<DATA>{
  final DATA? data;
  final Object? error;
  final bool build;

  const ValidatorState({
    this.data,
    this.error,
    this.build = false,
  });

  ValidatorState<DATA> copyWith({
    DATA? data,
    Object? error,
    bool? build,
  }) {
    return ValidatorState(
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