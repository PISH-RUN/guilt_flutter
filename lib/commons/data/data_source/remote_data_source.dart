import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:image_picker/image_picker.dart';

import '../model/server_failure.dart';

abstract class RemoteDataSource {
  Future<Either<ServerFailure, T>> putToServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    bool isTokenNeed = true,
    String? localKey,
  });

  Future<Either<ServerFailure, T>> patchToServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    bool isTokenNeed = true,
    String? localKey,
  });

  Future<Either<ServerFailure, T>> postToServer<T>({
    required String url,
    required dynamic params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    bool isTokenNeed = true,
    String? localKey,
  });

  Future<Either<ServerFailure, T>> deleteToServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    bool isTokenNeed = true,
  });

  Future<Either<ServerFailure, T>> getFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
    bool isTokenNeed = true,
    String customiseToken = "",
    String? localKey,
    Duration? expireDateLocalKey,
  });

  Future<Either<ServerFailure, List<T>>> getListFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required List<T> Function(List<dynamic> success) mapSuccess,
    bool isTokenNeed = true,
    String? localKey,
    Duration? expireDateLocalKey,
    bool isForceRefresh = false,
  });

  Future<Either<Failure, String>> postMultipartToServer({
    required String url,
    required String imageName,
    required XFile imageFile,
    required String attachName,
    required Map<String, dynamic> bodyParameters,
    bool isTokenNeed = true,
    String? localKey,
  });
}
