import 'dart:convert';

import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_local_repository.dart';
import 'package:collection/collection.dart';

class GuildLocalRepositoryImpl implements GuildLocalRepository {
  final String Function(String key) readData;
  final bool Function(String key) hasData;
  final void Function(String key, String value) writeData;

  final String _key = 'guildListKey';

  GuildLocalRepositoryImpl({
    required this.readData,
    required this.hasData,
    required this.writeData,
  });

  @override
  Guild? getFullDetailOfOneGuild(int userId, int guildId) {
    List<Guild> localGuildList = getListOfMyGuilds(userId) ?? [];
    return localGuildList.firstWhereOrNull((element) => element.id == guildId);
  }

  @override
  List<Guild>? getListOfMyGuilds(int userId) {
    return (jsonDecode(readData('$_key $userId')) as List).map((json) => GuildModel.fromJson(json)).toList();
  }

  @override
  void upsertGuildInLocal(int userId, List<Guild> guildList) {
    List<Guild> localGuildList = getListOfMyGuilds(userId) ?? [];
    localGuildList = [...guildList, ...localGuildList];
    writeData('$_key $userId', jsonEncode(localGuildList.toSet().toList()));
  }
}
