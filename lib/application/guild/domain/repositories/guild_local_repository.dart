import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';

abstract class GuildLocalRepository {
  Guild? getFullDetailOfOneGuild(String userId, int guildId);

  List<Guild>? getListOfMyGuilds(String userId);

  void upsertGuildInLocal(String userId, List<Guild> guildList);
}
