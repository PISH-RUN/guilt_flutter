import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/failures.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.success() = Success;

  const factory RegisterState.loading() = Loading;

  const factory RegisterState.readyToInput() = ReadyToInput;

  const factory RegisterState.error({required Failure failure}) = Error;
}
