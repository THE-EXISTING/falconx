// Created by Nonthawit on 29/9/2024 AD Lead Flutter at NEXTZY and EXISTING
import 'package:falconx/lib.dart';

enum PopResultStatus {
  info,
  fail,
  warning,
  success,
}

class PopResult<D extends Object?> extends Equatable {
  const PopResult.success([
    this.data,
  ]) : status = PopResultStatus.success;

  const PopResult.fail([
    this.data,
  ]) : status = PopResultStatus.fail;

  const PopResult.warning([
    this.data,
  ]) : status = PopResultStatus.warning;

  const PopResult.info([
    this.data,
  ]) : status = PopResultStatus.info;

  final PopResultStatus status;
  final D? data;

  bool get isSuccess => status == PopResultStatus.success;

  bool get isFail => status == PopResultStatus.fail;

  bool get isWarning => status == PopResultStatus.warning;

  bool get isInfo => status == PopResultStatus.info;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [status];
}
