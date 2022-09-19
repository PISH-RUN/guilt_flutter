import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/psp/data/models/guild_psp_model.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import '../../../../application/constants.dart';
import '../../domain/repositories/psp_repository.dart';

class PspRepositoryImpl implements PspRepository {
  final RemoteDataSource remoteDataSource;

  PspRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page) {
    final output = remoteDataSource.getFromServer<List<GuildPsp>>(
      url: '${BASE_URL_API}users/me',
      params: {},
      mapSuccess: (Map<String, dynamic> json) => JsonParser.listParser(json, ['data']).map((element) => GuildPspModel.fromJson(element)).toList(),
    );
    return output;
  }

  @override
  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guild) async {
    final output = await remoteDataSource.postToServer<bool>(
      url: '${BASE_URL_API}users/me',
      params: {},
      mapSuccess: (Map<String, dynamic> json) => true,
    );
    return RequestResult.fromEither(output);
  }
}
