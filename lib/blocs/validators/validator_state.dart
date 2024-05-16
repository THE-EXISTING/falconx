import 'package:falconx/lib.dart';

class ValidateState<DATA>{
  final DATA? data;
  final Failure? failure;
  final bool canBuild;

  const ValidateState({
    this.data,
    this.failure,
    this.canBuild = false,
  });

  ValidateState<DATA> copyWith({
    DATA? data,
    Failure? failure,
    bool? build,
  }) {
    return ValidateState(
      data: data ?? this.data,
      failure: failure ?? this.failure,
      canBuild: build ?? this.canBuild,
    );
  }

  @override
  String toString() {
    return 'ValidatorState{data: $data, failure: $failure, build: $canBuild}';
  }
}