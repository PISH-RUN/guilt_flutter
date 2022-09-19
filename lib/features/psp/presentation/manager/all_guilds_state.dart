import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';

part 'all_guilds_state.freezed.dart';

@freezed
class AllGuildsState with _$AllGuildsState {
  const factory AllGuildsState.loading() = Loading;

  const factory AllGuildsState.empty() = Empty;

  const factory AllGuildsState.error({required Failure failure}) = Error;

  const factory AllGuildsState.loaded({required List<GuildPsp> guildList}) = Loaded;
}
