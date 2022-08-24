import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';


part 'guild_list_state.freezed.dart';

@freezed
class GuildListState with _$GuildListState {
  const factory GuildListState.loaded({required List<Guild> guildList}) = Loaded;
  const factory GuildListState.loading() = Loading;
  const factory GuildListState.error({required Failure failure}) = Error;
  const factory GuildListState.empty() = Empty;
}