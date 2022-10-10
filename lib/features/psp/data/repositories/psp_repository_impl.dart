import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/data/model/paginate_list.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/psp/constants.dart';
import 'package:guilt_flutter/features/psp/data/models/guild_psp_model.dart';
import 'package:guilt_flutter/features/psp/data/models/psp_user_model.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/domain/entities/psp_user.dart';

import '../../../../application/constants.dart';
import '../../domain/repositories/psp_repository.dart';

class PspRepositoryImpl implements PspRepository {
  final RemoteDataSource remoteDataSource;

  PspRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginateList<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page, String searchText) async {
    final output = await remoteDataSource.postToServer<PaginateList<GuildPsp>>(
      url: '${BASE_URL_API}guilds?page=${page - 1}&pageSize=$perPageGuildItem',
      params: cities.isEmpty ? {} : {'cities': cities},
      mapSuccess: (Map<String, dynamic> json) => PaginateList(
        list: JsonParser.listParser(json, ['data', 'results']).map((element) => GuildPspModel.fromJson(element)).toList(),
        currentPage: page,
        perPage: perPageGuildItem,
        totalPage: (JsonParser.intParser(json, ['data', 'total']) ~/ perPageGuildItem),
      ),
    );
    return output;
  }

  @override
  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guild, {bool isJustState = true, String token = ""}) async {
    if (!isJustState) {
      final output = await remoteDataSource.putToServer<bool>(
        url: '${BASE_URL_API}guilds/${guild.guild.uuid}/psps',
        params: {...GuildModel.fromSuper(guild.guild).toJson(), 'user_token': token},
        mapSuccess: (Map<String, dynamic> json) => true,
      );
      return RequestResult.fromEither(output);
    } else {
      final output = await remoteDataSource.postToServer<bool>(
        url: '${BASE_URL_API}users/psps/guilds',
        params: {'status': guild.guildPspStep.name, 'guild_uuid': guild.guild.uuid},
        mapSuccess: (Map<String, dynamic> json) => true,
      );
      return RequestResult.fromEither(output);
    }
  }

  @override
  Future<Either<Failure, PaginateList<GuildPsp>>> getFollowUpGuildList(int page, List<String> cities, String searchText) async {
    final output = await remoteDataSource.getFromServer<PaginateList<GuildPsp>>(
      url: '${BASE_URL_API}users/psps/guilds?page=${page - 1}=0&pageSize=$perPageGuildItem',
      params: cities.isEmpty ? {} : {'cities': cities},
      mapSuccess: (Map<String, dynamic> json) {
        return PaginateList(
          list: JsonParser.listParser(json, ['data', 'results']).map((element) => GuildPspModel.fromJson(element)).toList(),
          currentPage: page,
          perPage: perPageGuildItem,
          totalPage: (JsonParser.intParser(json, ['data', 'total']) ~/ perPageGuildItem),
        );
      },
    );
    return output;
  }

  @override
  Future<Either<Failure, String>> getUserPhoneNumber(int userId) {
    return remoteDataSource.getFromServer<String>(
      url: '${BASE_URL_API}users/$userId',
      params: {},
      mapSuccess: (Map<String, dynamic> json) => JsonParser.stringParser(json, ['data', 'mobile']),
    );
  }

  @override
  Future<RequestResult> signUpPsp(PspUser pspUser) async {
    return RequestResult.fromEither(await remoteDataSource.postToServer<String>(
      url: '${BASE_URL_API}users/psps',
      params: PspUserModel.fromSuper(pspUser).toJson(),
      mapSuccess: (Map<String, dynamic> json) => "",
    ));
  }
}
