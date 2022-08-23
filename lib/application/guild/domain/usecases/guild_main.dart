import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_local_repository.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

class GuildMain {
  final GuildLocalRepository guildLocalRepository;
  final GuildRemoteRepository guildRemoteRepository;

  GuildMain(this.guildLocalRepository, this.guildRemoteRepository);

  Future<RequestResult> updateGuild({required int userId, required Guild guild}) async {
    guildLocalRepository.upsertGuildInLocal(userId, [guild]);
    return guildRemoteRepository.updateData(guild);
  }

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds({required int userId, bool isForceFromServer = false}) async {
    if (!isForceFromServer) {
      final guildList = guildLocalRepository.getListOfMyGuilds(userId);
      if (guildList != null) {
        return Right(guildList);
      }
    }
    return guildRemoteRepository.getListOfMyGuilds(userId);
  }

  Future<Either<Failure, Guild>> getFullDetailOfOneGuild({required int userId, required int guildId, bool isForceFromServer = false}) async {
    if (!isForceFromServer) {
      final guild = guildLocalRepository.getFullDetailOfOneGuild(userId, guildId);
      if (guild != null) {
        return Right(guild);
      }
    }
    return guildRemoteRepository.getFullDetailOfOneGuild(guildId);
  }
}
