import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/data/model/paginate_list.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/psp/constants.dart';
import 'package:guilt_flutter/features/psp/data/models/guild_psp_model.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:logger/logger.dart';

import '../../../../application/constants.dart';
import '../../domain/repositories/psp_repository.dart';

class PspRepositoryImpl implements PspRepository {
  final RemoteDataSource remoteDataSource;

  PspRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginateList<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page, bool isJustMine, String searchText) async {
    final output = await remoteDataSource.postToServer<PaginateList<GuildPsp>>(
      url: '${BASE_URL_API}guilds?page=${page - 1}&pageSize=$perPageGuildItem',
      params: {
        'cities': ['فیروزکوه']
      },
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
  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guild, String token) async {
    final output = await remoteDataSource.postToServer<bool>(
      url: '${BASE_URL_API}users/psps/guilds',
      params: {'guild_id': guild.guild.id, 'status': guild.guildPspStep.name},
      mapSuccess: (Map<String, dynamic> json) => true,
    );
    return RequestResult.fromEither(output);
  }
}
