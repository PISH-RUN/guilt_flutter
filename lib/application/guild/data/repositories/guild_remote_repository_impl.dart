import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GuildRemoteRepositoryImpl implements GuildRemoteRepository {
  final RemoteDataSource remoteDataSource;

  GuildRemoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(String nationalCode) {
    return remoteDataSource.getListFromServer<Guild>(
      url: '$BASE_URL_API/api/v1/users/record/$nationalCode',
      params: {},
      mapSuccess: (data) => data.mapIndexed((index, json) => GuildModel.fromJson(json, index)).toList(),
    );
  }

  Map<String, String> get defaultHeader {
    var output = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    String token = GetStorage().read<String>(TOKEN_KEY_SAVE_IN_LOCAL) ?? "";
    if (token.isNotEmpty) {
      String preFix = "Bearer";
      output['Authorization'] = '$preFix $token';
    }
    return output;
  }


  @override
  Future<RequestResult> updateAllData(String nationalCode, List<Guild> guildList) async {
    Logger().i("info=>4 ${guildList} ");
    final json = guildList.map((guild) => GuildModel.fromSuper(guild).toJson()).toList();
    try {
      http.Response finalResponse = await http.Client().post(
        Uri.parse('$BASE_URL_API/api/v1/users/record/$nationalCode/upsert'),
        body: jsonEncode(json),
        headers: defaultHeader,
      );
      if (isSuccessfulHttp(finalResponse)) {
        return RequestResult.success();
      } else {
        handleGlobalErrorInServer(finalResponse);
        return RequestResult.failure(
          finalResponse.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE
              ? ServerFailure.notLoggedInYet()
              : finalResponse.statusCode == FORBIDDEN_STATUS_CODE
                  ? ServerFailure.notBuyAccountYet()
                  : ServerFailure(finalResponse),
        );
      }
    } on Exception {
      return RequestResult.failure(ServerFailure.somethingWentWrong());
    }
  }

  void handleGlobalErrorInServer(http.Response response) {
    if (response.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE) GetIt.instance<LoginApi>().signOut();
  }

  @override
  Future<Either<Failure, Guild>> addData(String nationalCode, Guild guild) async {
    final output = await remoteDataSource.postToServer(
      url: '$BASE_URL_API/api/v1/users/record/$nationalCode',
      params: GuildModel.fromSuper(guild).toJson(),
      mapSuccess: (date) => guild,
    );
    return output;
  }
}
