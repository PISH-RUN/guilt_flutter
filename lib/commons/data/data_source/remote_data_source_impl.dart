import 'dart:convert';
import 'dart:io';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart';
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

  Map<String, String> get publicHeader {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Map<String, String> get authenticateHeader {
    var output = publicHeader;
    String token = GetIt.instance<LoginApi>().getUserData().token;
    if (token.isNotEmpty) {
      String preFix = "Bearer";
      output['Authorization'] = '$preFix $token';
    }
    return output;
  }

  Map<String, String> getHeader(bool isTokenNeed) => isTokenNeed ? authenticateHeader : publicHeader;

  @override
  Future<Either<ServerFailure, List<T>>> getListFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required List<T> Function(List<dynamic> success) mapSuccess,
    String? localKey,
    Duration? expireDateLocalKey,
    bool isTokenNeed = true,
    bool isForceRefresh = false,
  }) async {
    String methodName = "getList";
    if (localKey != null && GetStorage().hasData(localKey) && !isForceRefresh) {
      if (expireDateLocalKey != null && isExpireDateArrived(expireDateLocalKey, localKey)) {
        GetStorage().remove(localKey);
        GetStorage().remove("modifyAt-$localKey");
      } else {
        return Right(mapSuccess((jsonDecode(GetStorage().read(localKey)) as List)));
      }
    }
    try {
      Logger().v("$methodName===> url ===> $url \n\nbodyParameters ===> $params\n\ndefaultHeader ===> ${getHeader(isTokenNeed)}");
      final finalUri = Uri.parse(url).replace(queryParameters: params);
      http.Response finalResponse = await client.get(finalUri, headers: getHeader(isTokenNeed));
      Logger().d("$methodName===> response.statusCode==> ${finalResponse.statusCode}  for  $url");
      if (isSuccessfulHttp(finalResponse)) {
        Logger().i("$methodName===>$url response is===>${finalResponse.body}");
        if (localKey != null) {
          GetStorage().write(localKey, finalResponse.body);
          GetStorage().write("modifyAt-$localKey", DateTime.now().millisecondsSinceEpoch);
        }
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
  Future<Either<ServerFailure, T>> getFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    String? localKey,
    bool isTokenNeed = true,
    Duration? expireDateLocalKey = const Duration(hours: 1),
  }) async {
    if (localKey != null && GetStorage().hasData(localKey)) {
      if (expireDateLocalKey != null && isExpireDateArrived(expireDateLocalKey, localKey)) {
        GetStorage().remove(localKey);
        GetStorage().remove("modifyAt-$localKey");
      } else {
        return Right(convertStringToSuccessData(GetStorage().read<String>(localKey)!, (success) => mapSuccess(success)));
      }
    }
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    String paramsString = params.entries.map((entry) => "${entry.key}=${entry.value}").toList().join('&');
    if (paramsString.isNotEmpty) {
      paramsString = "?$paramsString";
    }
    final finalUri = Uri.parse('$url$paramsString');
    final response = await _callFunctionOfServer(
      response: client.get(finalUri, headers: url.contains("dapi") ? {'Accept': 'application/json'} : getHeader(isTokenNeed)),
      params: params,
      url: url,
      isTokenNeed: isTokenNeed,
      methodName: "get",
    );
    return response.fold(
      (l) => Left(l),
      (data) {
        if (localKey != null) {
          GetStorage().write(localKey, data);
          GetStorage().write("modifyAt-$localKey", DateTime.now().millisecondsSinceEpoch);
        }
        return Right(convertStringToSuccessData(data, (success) => mapSuccess(success)));
      },
    );
  }

  bool isExpireDateArrived(Duration expireDateLocalKey, String localKey) =>
      expireDateLocalKey.inSeconds < (DateTime.now().millisecondsSinceEpoch - (GetStorage().read<int>("modifyAt-$localKey") ?? 0) / 1000);

  @override
  Future<Either<ServerFailure, T>> postToServer<T>({
    required String url,
    required dynamic params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    bool isTokenNeed = true,
    String? localKey,
  }) async {
    if (!await isInternetEnable()) {
      return Left(ServerFailure.noInternet());
    }
    final response = await _callFunctionOfServer(
      response: client.post(Uri.parse(url), body: jsonEncode(params), headers: getHeader(isTokenNeed)),
      params: params,
      url: url,
      isTokenNeed: isTokenNeed,
      methodName: "post",
    );
    return response.fold(
      (l) => Left(l),
      (data) {
        if (localKey != null) {
          GetStorage().write(localKey, data);
          GetStorage().write("modifyAt-$localKey", DateTime.now().millisecondsSinceEpoch);
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
      bool isTokenNeed = true,
      String? localKey}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    final response = await _callFunctionOfServer(
      response: client.put(Uri.parse(url), body: jsonEncode(params), headers: getHeader(isTokenNeed)),
      params: params,
      url: url,
      isTokenNeed: isTokenNeed,
      methodName: "put",
    );
    return response.fold(
      (l) => Left(l),
      (data) {
        if (localKey != null) {
          GetStorage().write(localKey, data);
          GetStorage().write("modifyAt-$localKey", DateTime.now().millisecondsSinceEpoch);
        }
        return Right(convertStringToSuccessData(data, (success) => mapSuccess(success)));
      },
    );
  }

  @override
  Future<Either<ServerFailure, T>> patchToServer<T>(
      {required String url,
      required Map<String, dynamic> params,
      required T Function(Map<String, dynamic> success) mapSuccess,
      bool isTokenNeed = true,
      String? localKey}) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    final response = await _callFunctionOfServer(
      response: client.patch(Uri.parse(url), body: jsonEncode(params), headers: getHeader(isTokenNeed)),
      params: params,
      url: url,
      isTokenNeed: isTokenNeed,
      methodName: "patch",
    );
    return response.fold(
      (l) => Left(l),
      (data) {
        if (localKey != null) {
          GetStorage().write(localKey, data);
          GetStorage().write("modifyAt-$localKey", DateTime.now().millisecondsSinceEpoch);
        }
        return Right(convertStringToSuccessData(data, (success) => mapSuccess(success)));
      },
    );
  }

  Future<Either<ServerFailure, String>> _callFunctionOfServer<T>({
    required String methodName,
    required Future<http.Response> response,
    required String url,
    required dynamic params,
    required isTokenNeed,
  }) async {
    try {
      Logger().v("$methodName===> url ===> $url \n\nbodyParameters ===> $params\n\ndefaultHeader ===> ${getHeader(isTokenNeed)}");
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
    writeDataToLocal(LocalKeys.token.name, "");
  }

  @override
  Future<Either<ServerFailure, T>> deleteToServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    bool isTokenNeed = true,
  }) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    final response = await _callFunctionOfServer(
      response: client.delete(Uri.parse(url), body: jsonEncode(params), headers: getHeader(isTokenNeed)),
      params: params,
      url: url,
      isTokenNeed: isTokenNeed,
      methodName: "delete",
    );
    return response.fold(
      (l) => Left(l),
      (data) => Right(convertStringToSuccessData(data, (success) => mapSuccess(success))),
    );
  }

  @override
  Future<Either<Failure, String>> postMultipartToServer({
    required String url,
    required String imageName,
    required XFile imageFile,
    required String attachName,
    required Map<String, dynamic> bodyParameters,
    bool isTokenNeed = true,
    String? localKey,
  }) async {
    if (!await isInternetEnable()) return Left(ServerFailure.noInternet());
    try {
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl = url;
      dioRequest.options.headers = getHeader(isTokenNeed);

      Image image = decodeImage(File(imageFile.path).readAsBytesSync())!;
      Image thumbnail = copyResize(image, width: 700);
      await File(imageFile.path).writeAsBytes(encodePng(thumbnail));

      var formData = dio.FormData.fromMap({
        imageName: await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: MediaType("image", imageFile.path.split('.').last),
        ),
      });
      bodyParameters.forEach((key, value) {
        if (value != null) formData.fields.add(MapEntry(key, value.toString()));
      });
      var response = await dioRequest.post(url, data: formData);
      Logger().i("statusCode=> ${response.statusCode!} ");
      if (isSuccessfulStatusCode(response.statusCode!)) {
        Logger().i("data=> ${response.data} ");
        return Right(response.data.toString());
      } else {
        Logger().e("error=> ${response.data} ");
        return Left(Failure('attach wrong'));
      }
    } on dio.DioError catch (e) {
      Logger().wtf("wtf=> ${e.message}    ${e.response.toString()}");
      if (e.message.contains('413')) return Left(Failure("حجم عکس نباید بیش از یک مگابایت باشد"));
      return Left(Failure('attach wrong'));
    }
  }
}
