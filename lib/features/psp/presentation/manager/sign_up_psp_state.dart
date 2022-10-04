import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/failures.dart';

part 'sign_up_psp_state.freezed.dart';

@freezed
class SignUpPspState with _$SignUpPspState {
  const factory SignUpPspState.loading() = Loading;

  const factory SignUpPspState.error({required Failure failure}) = Error;

  const factory SignUpPspState.readyToInput() = ReadyToInput;

  const factory SignUpPspState.success() = Success;
}
