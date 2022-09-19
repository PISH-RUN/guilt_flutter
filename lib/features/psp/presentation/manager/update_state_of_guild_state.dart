import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/failures.dart';

part 'update_state_of_guild_state.freezed.dart';

@freezed
class UpdateStateOfGuildState with _$UpdateStateOfGuildState {
  const factory UpdateStateOfGuildState.loading() = Loading;

  const factory UpdateStateOfGuildState.error({required Failure failure}) = Error;

  const factory UpdateStateOfGuildState.readyToInput() = ReadyToInput;

  const factory UpdateStateOfGuildState.success() = Success;
}
