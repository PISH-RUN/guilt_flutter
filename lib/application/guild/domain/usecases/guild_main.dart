import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

class GuildMain {
  final GuildRemoteRepository guildRemoteRepository;

  List<Guild> guildList = [];

  GuildMain(this.guildRemoteRepository);

  Future<RequestResult> updateGuild({required String nationalCode, required Guild guild}) async {
    guildRemoteRepository.updateSpecialGuild(guild);
    getListOfMyGuilds(nationalCode: nationalCode);
    return RequestResult.success();
  }

  Future<RequestResult> addGuild({required String nationalCode, required Guild guild}) async {
    guild = guild.copyWith(id: guildList.length);
    final response = await guildRemoteRepository.addGuild(nationalCode, guild);
    if (response.isLeft()) {
      return RequestResult.fromEither(response);
    }
    guildList.add(GuildModel.fromSuper(guild));
    return RequestResult.fromEither(response);
  }

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds({required String nationalCode, bool isForceRefresh = false}) async {
    return (await guildRemoteRepository.getListOfMyGuilds(nationalCode, isForceRefresh)).fold((l) => left(l), (r) {
      guildList = r;
      return Right(r);
    });
  }

  Future<Either<Failure, Guild>> getFullDetailOfOneGuild({required String nationalCode, required int guildId, bool isForceFromServer = false}) async {
    final response = await getListOfMyGuilds(nationalCode: nationalCode);
    return response.fold((l) => Left(l), (guildList) => Right(guildList.firstWhere((element) => element.id == guildId)));
  }
}
