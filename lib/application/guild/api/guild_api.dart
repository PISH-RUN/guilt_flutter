import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

class GuildApi {
  final GuildRemoteRepository guildRemoteRepository;

  GuildApi({required this.guildRemoteRepository});

  Future<Either<Failure, List<Guild>>> getMyGuildList({required String nationalCode, bool isForceRefresh = false}) async {
    return guildRemoteRepository.getListOfMyGuilds(nationalCode);
  }

  Future<RequestResult> updateGuildList({required String nationalCode, required Guild guildItem}) async {
    return guildRemoteRepository.updateSpecialGuild(guildItem);
  }
}
