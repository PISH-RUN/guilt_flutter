import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/failures.dart';

part 'update_user_state.freezed.dart';

@freezed
class UpdateUserState with _$UpdateUserState {
  const factory UpdateUserState.loading() = Loading;

  const factory UpdateUserState.error({required Failure failure}) = Error;

  const factory UpdateUserState.readyToInput() = ReadyToInput;

  const factory UpdateUserState.success() = Success;
}
