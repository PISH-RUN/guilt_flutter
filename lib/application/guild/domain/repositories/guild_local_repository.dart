import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';

abstract class GuildLocalRepository {
  Guild? getFullDetailOfOneGuild(int userId, int guildId);

  List<Guild>? getListOfMyGuilds(int userId);

  void upsertGuildInLocal(int userId, List<Guild> guildList);
}
