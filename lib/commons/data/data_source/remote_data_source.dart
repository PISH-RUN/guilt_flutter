import 'package:dartz/dartz.dart';

import '../model/server_failure.dart';

abstract class RemoteDataSource {
  Future<Either<ServerFailure, T>> putToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess});

  Future<Either<ServerFailure, T>> postToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess});

  Future<Either<ServerFailure, T>> deleteToServer<T>(
      {required String url, required Map<String, dynamic> params, required T Function(Map<String, dynamic> success) mapSuccess});

  Future<Either<ServerFailure, T>> getFromServer<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
  });

  Stream<Either<ServerFailure, T>> getFromServerWithOfflineFirst<T>({
    required String url,
    required Map<String, dynamic> params,
    required T Function(Map<String, dynamic> success) mapSuccess,
  });

  Future<Either<ServerFailure, List<T>>> getListFromServer<T>(
      {required String url, required Map<String, dynamic> params, required List<T> Function(List<dynamic> success) mapSuccess});
}
