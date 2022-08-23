import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

class GuildRemoteRepositoryImpl implements GuildRemoteRepository {
  final RemoteDataSource remoteDataSource;

  GuildRemoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Guild>> getFullDetailOfOneGuild(int guildId) {
    // TODO: implement getFullDetailOfOneGuild
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(int userId) {
    // TODO: implement getListOfMyGuilds
    throw UnimplementedError();
  }

  @override
  Future<RequestResult> updateData(Guild guild) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
