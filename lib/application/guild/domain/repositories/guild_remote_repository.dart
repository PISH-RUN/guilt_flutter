import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

abstract class GuildRemoteRepository {

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(String userId);

  Future<RequestResult> updateAllData(String nationalCode, List<Guild> guildList);

  Future<Either<Failure, Guild>> addData(String nationalCode, Guild guild);
}
