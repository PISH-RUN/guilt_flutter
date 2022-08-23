import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../utils.dart';
import '../model/server_failure.dart';
import 'remote_data_source.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final Function isInternetEnable;
  final String Function(String key) readDataFromLocal;
  final void Function(String key, String value) writeDataToLocal;

  RemoteDataSourceImpl({required this.client, required this.isInternetEnable, required this.readDataFromLocal, required this.writeDataToLocal});

  Map<String, String> get defaultHeader {
    var output = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    String token = readDataFromLocal(TOKEN_KEY_SAVE_IN_LOCAL);
    if (token.isNotEmpty) {
      String preFix = "Bearer";
      output['Authorization'] = '$preFix $token';
    }
    return output;
  }

  @override
  Future<Either<ServerFailure, List<T>>> getListFromServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess}) async {
    String methodName = "getList";
    try {
      Logger().v("$methodName===> url ===> $url \n\nbodyParameters ===> $params\n\ndefaultHeader ===> $defaultHeader");
      final finalUri = Uri.parse(url).replace(queryParameters: params);
      http.Response finalResponse = await client.get(finalUri, headers: defaultHeader);
      Logger().d("$methodName===> response.statusCode==> ${finalResponse.statusCode}  for  $url");
      if (isSuccessfulHttp(finalResponse)) {
        Logger().i("$methodName===>$url response is===>${finalResponse.body}");
        return Right((jsonDecode(finalResponse.body) as List).map((e) => mapSuccess(e)).toList());
      } else {
        Logger().e("$methodName===> response.error ===> ${finalResponse.body}");
        handleGlobalErrorInServer(finalResponse);
        return Left(finalResponse.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE
            ? ServerFailure.notLoggedInYet()
            : finalResponse.statusCode == FORBIDDEN_STATUS_CODE
                ? ServerFailure.notBuyAccountYet()
                : ServerFailure(finalResponse));
      }
    } on Exception catch (e) {
      Logger().wtf("$methodName===> crash ===> ${e.toString()}  for  $url");
      return Left(ServerFailure.somethingWentWrong());
    }
  }

  @override
  Future<Either<ServerFailure, T>> getFromServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    String paramsString = params.entries.map((entry) => "${entry.key}=${entry.value}").toList().join('&');
    if (paramsString.isNotEmpty) {
      paramsString = "?$paramsString";
    }
    final finalUri = Uri.parse('$url$paramsString');
    return _callFunctionOfServer(
      response: client.get(finalUri, headers: url.contains("dapi") ? {'Accept': 'application/json'} : defaultHeader),
      mapSuccess: mapSuccess,
      params: params,
      url: url,
      methodName: "get",
    );
  }

  @override
  Stream<Either<ServerFailure, T>> getFromServerWithOfflineFirst<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess}) async* {
    final finalUri = Uri.parse(url).replace(queryParameters: params);
    if (GetStorage().hasData(finalUri.toString())) {
      yield Right(mapSuccess(GetStorage().read<Map<String, dynamic>>(finalUri.toString())!));
    }
    if (!await isInternetEnable()) {
      yield Left(ServerFailure.noInternet());
    } else {
      final output = await _callFunctionOfServer<Map<String, dynamic>>(
        response: client.get(finalUri, headers: defaultHeader),
        mapSuccess: (data) => data,
        params: params,
        url: url,
        methodName: "get",
      );
      yield output.fold(
        (l) => Left(l),
        (r) {
          GetStorage().write(finalUri.toString(), r);
          return Right(mapSuccess(r));
        },
      );
    }
  }

  @override
  Future<Either<ServerFailure, T>> postToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    return _callFunctionOfServer(
      response: client.post(Uri.parse(url), body: jsonEncode(params), headers: defaultHeader),
      mapSuccess: mapSuccess,
      params: params,
      url: url,
      methodName: "post",
    );
  }

  @override
  Future<Either<ServerFailure, T>> putToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    return _callFunctionOfServer(
      response: client.put(Uri.parse(url), body: jsonEncode(params), headers: defaultHeader),
      mapSuccess: mapSuccess,
      params: params,
      url: url,
      methodName: "put",
    );
  }

  Future<Either<ServerFailure, T>> _callFunctionOfServer<T>({
    required String methodName,
    required Future<http.Response> response,
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
  }) async {
    try {
      Logger().v("$methodName===> url ===> $url \n\nbodyParameters ===> $params\n\ndefaultHeader ===> $defaultHeader");
      http.Response finalResponse = await response;
      Logger().d("$methodName===> response.statusCode==> ${finalResponse.statusCode}  for  $url");
      if (isSuccessfulHttp(finalResponse)) {
        Logger().i("$methodName===>$url response is===>${finalResponse.body}");
        return Right(mapSuccess(jsonDecode(finalResponse.body)));
      } else {
        Logger().e("$methodName===> response.error ===> ${finalResponse.statusCode}  ${finalResponse.body}");
        handleGlobalErrorInServer(finalResponse);
        return Left(
          finalResponse.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE
              ? ServerFailure.notLoggedInYet()
              : finalResponse.statusCode == FORBIDDEN_STATUS_CODE
                  ? ServerFailure.notBuyAccountYet()
                  : ServerFailure(finalResponse),
        );
      }
    } on Exception catch (e) {
      Logger().wtf("$methodName===> crash ===> ${e.toString()}  for  $url");
      return Left(ServerFailure.somethingWentWrong());
    }
  }

  void handleGlobalErrorInServer(http.Response response) {
    if (response.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE) _removeTokenBecauseIfExpire(response);
  }

  void _removeTokenBecauseIfExpire(http.Response response) {
    writeDataToLocal(TOKEN_KEY_SAVE_IN_LOCAL, "");
  }

  @override
  Future<Either<ServerFailure, T>> deleteToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    return _callFunctionOfServer(
      response: client.delete(Uri.parse(url), body: jsonEncode(params), headers: defaultHeader),
      mapSuccess: mapSuccess,
      params: params,
      url: url,
      methodName: "delete",
    );
  }
}
