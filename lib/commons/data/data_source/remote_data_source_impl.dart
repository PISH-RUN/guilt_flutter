import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
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
  Future<Either<ServerFailure, List<T>>> getListFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required List<T> Function(List<dynamic> success) mapSuccess,
  }) async {
    String methodName = "getList";
    try {
      Logger().v("$methodName===> url ===> $url \n\nbodyParameters ===> $params\n\ndefaultHeader ===> $defaultHeader");
      final finalUri = Uri.parse(url).replace(queryParameters: params);
      http.Response finalResponse = await client.get(finalUri, headers: defaultHeader);
      Logger().d("$methodName===> response.statusCode==> ${finalResponse.statusCode}  for  $url");
      if (isSuccessfulHttp(finalResponse)) {
        Logger().i("$methodName===>$url response is===>${finalResponse.body}");
        return Right(mapSuccess((jsonDecode(finalResponse.body) as List)));
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
      return Left(ServerFailure.fromMessage(e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, T>> getFromServer<T>(
      {required String url,
      required Map<String, dynamic> params,
      required T Function(Map<String, dynamic> success) mapSuccess,
      String? localKey}) async {
    if (localKey != null && GetStorage().hasData(localKey)) {
      return Right(convertStringToSuccessData(GetStorage().read<String>(localKey)!, (success) => mapSuccess(success)));
    }
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    String paramsString = params.entries.map((entry) => "${entry.key}=${entry.value}").toList().join('&');
    if (paramsString.isNotEmpty) {
      paramsString = "?$paramsString";
    }
    final finalUri = Uri.parse('$url$paramsString');
    final response = await _callFunctionOfServer(
      response: client.get(finalUri, headers: url.contains("dapi") ? {'Accept': 'application/json'} : defaultHeader),
      params: params,
      url: url,
      methodName: "get",
    );
    return response.fold(
      (l) => Left(l),
      (data) {
        return Right(convertStringToSuccessData(data, (success) => mapSuccess(success)));
      },
    );
  }

  @override
  Future<Either<ServerFailure, T>> postToServer<T>(
      {required String url,
      required Map<String, dynamic> params,
      required T Function(Map<String, dynamic> success) mapSuccess,
      String? localKey}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    final response = await _callFunctionOfServer(
      response: client.post(Uri.parse(url), body: jsonEncode(params), headers: defaultHeader),
      params: params,
      url: url,
      methodName: "post",
    );
    return response.fold(
      (l) => Left(l),
      (data) {
        if (localKey != null) {
          GetStorage().write(localKey, data);
        }
        return Right(convertStringToSuccessData(data, (success) => mapSuccess(success)));
      },
    );
  }

  @override
  Future<Either<ServerFailure, T>> putToServer<T>(
      {required String url,
      required Map<String, dynamic> params,
      required T Function(Map<String, dynamic> success) mapSuccess,
      String? localKey}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    final response = await _callFunctionOfServer(
      response: client.put(Uri.parse(url), body: jsonEncode(params), headers: defaultHeader),
      params: params,
      url: url,
      methodName: "put",
    );
    return response.fold(
      (l) => Left(l),
      (data) {
        if (localKey != null) {
          GetStorage().write(localKey, data);
        }
        return Right(convertStringToSuccessData(data, (success) => mapSuccess(success)));
      },
    );
  }

  Future<Either<ServerFailure, String>> _callFunctionOfServer<T>({
    required String methodName,
    required Future<http.Response> response,
    required String url,
    required Map<String, dynamic> params,
  }) async {
    try {
      Logger().v("$methodName===> url ===> $url \n\nbodyParameters ===> $params\n\ndefaultHeader ===> $defaultHeader");
      http.Response finalResponse = await response;
      Logger().d("$methodName===> response.statusCode==> ${finalResponse.statusCode}  for  $url");
      if (isSuccessfulHttp(finalResponse)) {
        Logger().i("$methodName===>$url response is===>${finalResponse.body}");
        return Right(finalResponse.body);
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
      return Left(ServerFailure.fromMessage(e.toString()));
    }
  }

  T convertStringToSuccessData<T>(String data, T Function(Map<String, dynamic> success) mapSuccess) => mapSuccess(jsonDecode(data));

  void handleGlobalErrorInServer(http.Response response) {
    if (response.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE) _removeTokenBecauseIfExpire(response);
  }

  void _removeTokenBecauseIfExpire(http.Response response) {
    writeDataToLocal(TOKEN_KEY_SAVE_IN_LOCAL, "");
  }

  @override
  Future<Either<ServerFailure, T>> deleteToServer<T>(
      {required String url,
      required Map<String, dynamic> params,
      required T Function(Map<String, dynamic> success) mapSuccess,
      }) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    final response = await _callFunctionOfServer(
      response: client.delete(Uri.parse(url), body: jsonEncode(params), headers: defaultHeader),
      params: params,
      url: url,
      methodName: "delete",
    );
    return response.fold(
      (l) => Left(l),
      (data) => Right(convertStringToSuccessData(data, (success) => mapSuccess(success))),
    );
  }

  @override
  Future<RequestResult> postMultipartToServer({
    required String url,
    required String imageName,
    required XFile image,
    required String attachName,
    required Map<String, dynamic> bodyParameters,
    String? localKey,
  }) async {
    if (!await isInternetEnable()) return RequestResult.failure(ServerFailure.noInternet());
    try {
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl = url;
      dioRequest.options.headers = defaultHeader;
      var formData = dio.FormData.fromMap({});
      final bytes = await image.readAsBytes();
      final dio.MultipartFile file = dio.MultipartFile.fromBytes(bytes, filename: image.path.substring(image.path.lastIndexOf('/') + 1));
      MapEntry<String, dio.MultipartFile> entry = MapEntry(imageName, file);
      formData.files.add(entry);
      bodyParameters.forEach((key, value) {
        if (value != null) formData.fields.add(MapEntry(key, value.toString()));
      });
      var response = await dioRequest.post(url, data: formData);
      if (isSuccessfulStatusCode(response.statusCode!)) {
        if (localKey != null) {
          GetStorage().write(localKey, response.data.toString());
        }
        return RequestResult.success();
      } else {
        return RequestResult.failure(Failure('attach wrong'));
      }
    } on dio.DioError {
      return RequestResult.failure(Failure('attach wrong'));
    }
  }
}
