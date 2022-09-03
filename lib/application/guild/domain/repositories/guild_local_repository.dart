import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';

abstract class GuildLocalRepository {
  Guild? getFullDetailOfOneGuild(String userId, int guildId);

  List<Guild>? getListOfMyGuilds(String userId);

  void upsertGuildInLocal(String userId, List<Guild> guildList);

  void replaceData(String userId, List<Guild> guildList);
}
