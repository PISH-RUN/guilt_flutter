import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';

part 'guild_state.freezed.dart';

@freezed
class GuildState with _$GuildState {
  const factory GuildState.loaded({required Guild guild}) = Loaded;

  const factory GuildState.loading() = Loading;

  const factory GuildState.error({required Failure failure}) = Error;
}
