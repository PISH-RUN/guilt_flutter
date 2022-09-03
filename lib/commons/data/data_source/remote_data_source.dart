import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:image_picker/image_picker.dart';

import '../model/server_failure.dart';

abstract class RemoteDataSource {
  Future<Either<ServerFailure, T>> putToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess, String? localKey});

  Future<Either<ServerFailure, T>> postToServer<T>(
      {required String url, required dynamic params, required T Function(Map<String, dynamic> success) mapSuccess, String? localKey});

  Future<Either<ServerFailure, T>> deleteToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess});

  Future<Either<ServerFailure, T>> getFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    String? localKey,
  });

  Future<Either<ServerFailure, List<T>>> getListFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required List<T> Function(List<dynamic> success) mapSuccess,
    String? localKey,
    bool isForceRefresh = false,
  });

  Future<RequestResult> postMultipartToServer({
    required String url,
    required String imageName,
    required XFile image,
    required String attachName,
    required Map<String, dynamic> bodyParameters,
    String? localKey,
  });
}
