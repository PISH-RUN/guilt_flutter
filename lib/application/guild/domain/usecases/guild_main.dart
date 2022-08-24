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

  Future<RequestResult> updateGuild({required String nationalCode, required Guild guild}) async {
    guildLocalRepository.upsertGuildInLocal(nationalCode, [guild]);
    return guildRemoteRepository.updateData(nationalCode, guild);
  }

  Future<RequestResult> addGuild({required String nationalCode, required Guild guild}) async {
    final response = await guildRemoteRepository.addData(nationalCode, guild);
    if (response.isLeft()) {
      return RequestResult.fromEither(response);
    }
    guildLocalRepository.upsertGuildInLocal(nationalCode, [response.getOrElse(() => throw UnimplementedError())]);
    return RequestResult.fromEither(response);
  }

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds({required String nationalCode, bool isForceFromServer = false}) async {
    if (!isForceFromServer) {
      final guildList = guildLocalRepository.getListOfMyGuilds(nationalCode);
      if (guildList != null) {
        return Right(guildList);
      }
    }
    return guildRemoteRepository.getListOfMyGuilds(nationalCode);
  }

  Future<Either<Failure, Guild>> getFullDetailOfOneGuild({required String nationalCode, required int guildId, bool isForceFromServer = false}) async {
    if (!isForceFromServer) {
      final guild = guildLocalRepository.getFullDetailOfOneGuild(nationalCode, guildId);
      if (guild != null) {
        return Right(guild);
      }
    }
    return guildRemoteRepository.getFullDetailOfOneGuild(nationalCode, guildId);
  }
}
