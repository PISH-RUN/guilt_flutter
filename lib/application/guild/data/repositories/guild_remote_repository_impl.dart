import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

class GuildRemoteRepositoryImpl implements GuildRemoteRepository {
  final RemoteDataSource remoteDataSource;

  GuildRemoteRepositoryImpl({required this.remoteDataSource});

  List<Guild>? guildList;

  @override
  Future<Either<Failure, Guild>> getFullDetailOfOneGuild(String nationalCode, int guildId) async {
    if (guildList == null) {
      final response = await getListOfMyGuilds(nationalCode);
      if (response.isLeft()) {
        return Left(response.swap().getOrElse(() => throw UnimplementedError()));
      }
    }
    return Right(guildList!.firstWhere((element) => element.id == guildId));
  }

  @override
  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(String nationalCode) {
    return remoteDataSource.getFromServer(
      url: '$BASE_URL_API/api/v1/record/$nationalCode',
      params: {},
      mapSuccess: (date) {
        guildList = JsonParser.listParser(date, ['data']).mapIndexed((index, json) => GuildModel.fromJson(json, index)).toList();
        return guildList!;
      },
    );
  }

  @override
  Future<RequestResult> updateData(String nationalCode, Guild guild) async {
    guildList = (guildList ?? []).map((e) => e.id == guild.id ? guild : e).toList();
    guildList!.sort((a, b) => a.id.compareTo(b.id));
    final response = await remoteDataSource.postToServer(
      url: '$BASE_URL_API/api/v1/record/$nationalCode/upsert',
      params: jsonDecode(jsonEncode(guildList!.map((guild) => GuildModel.fromSuper(guild)))),
      mapSuccess: (date) => (date as List).mapIndexed((index, json) => GuildModel.fromJson(json, index)).toList(),
    );
    return RequestResult.fromEither(response);
  }

  @override
  Future<Either<Failure, Guild>> addData(String nationalCode, Guild guild) async {
    guild = guild.copyWith(id: (guildList ?? []).length);
    (guildList ?? []).add(guild);
    guildList!.sort((a, b) => a.id.compareTo(b.id));
    return remoteDataSource.postToServer(
      url: '$BASE_URL_API/api/v1/record/$nationalCode',
      params: GuildModel.fromSuper(guild).toJson(),
      mapSuccess: (date) => guild,
    );
  }
}
