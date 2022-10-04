import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/data/model/paginate_list.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';

part 'follow_up_guilds_state.freezed.dart';

@freezed
class FollowUpGuildsState with _$FollowUpGuildsState {
  const factory FollowUpGuildsState.loading() = Loading;

  const factory FollowUpGuildsState.empty() = Empty;

  const factory FollowUpGuildsState.error({required Failure failure}) = Error;

  const factory FollowUpGuildsState.loaded({required PaginateList<GuildPsp> guildList}) = Loaded;
}
