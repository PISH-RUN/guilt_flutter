import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

abstract class GuildRemoteRepository {
  Future<Either<Failure, Guild>> getFullDetailOfOneGuild(int guildId);

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(int userId);
  Future<RequestResult> updateData(Guild guild);
}
