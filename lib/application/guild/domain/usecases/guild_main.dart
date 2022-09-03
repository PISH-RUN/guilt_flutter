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
    List<GuildModel> localGuildList = guildList.map((e) => GuildModel.fromSuper(e)).toList();
    localGuildList = [GuildModel.fromSuper(guild), ...(guildList.map((e) => GuildModel.fromSuper(e)).toList())].toSet().toList();
    // guildLocalRepository.upsertGuildInLocal(nationalCode, localGuildList);
    guildRemoteRepository.updateAllData(nationalCode, localGuildList);
    return RequestResult.success();
  }

  Future<RequestResult> addGuild({required String nationalCode, required Guild guild}) async {
    guild = guild.copyWith(id: guildList.length);
    final response = await guildRemoteRepository.addGuild(nationalCode, guild);
    if (response.isLeft()) {
      return RequestResult.fromEither(response);
    }
    guildList.add(GuildModel.fromSuper(guild));
    // guildLocalRepository.upsertGuildInLocal(nationalCode, guildList);
    return RequestResult.fromEither(response);
  }

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds({required String nationalCode, bool isForceRefresh = false}) async {
    return guildRemoteRepository.getListOfMyGuilds(nationalCode,isForceRefresh);
  }

  Future<Either<Failure, Guild>> getFullDetailOfOneGuild({required String nationalCode, required int guildId, bool isForceFromServer = false}) async {
    final response = await getListOfMyGuilds(nationalCode: nationalCode);
    return response.fold((l) => Left(l), (guildList) => Right(guildList.firstWhere((element) => element.id == guildId)));
  }
}
