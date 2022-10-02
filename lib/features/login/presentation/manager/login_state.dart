import 'package:guilt_flutter/commons/failures.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_data.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.success({required UserData userData}) = Success;

  const factory LoginState.loading() = Loading;

  const factory LoginState.readyToInput() = ReadyToInput;

  const factory LoginState.error({required Failure failure}) = Error;
}
