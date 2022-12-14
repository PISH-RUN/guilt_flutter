import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:guilt_flutter/commons/failures.dart';

enum DataMode { loading, success, error, successCache, successCacheAndError }

enum TopLoadingBarState { normal, loading, noNet }

class OfflineFirstData<T> {
  final T? data;
  final Failure? error;
  final bool isDataFromCache;

  const OfflineFirstData({
    required this.data,
    required this.error,
    required this.isDataFromCache,
  });

  factory OfflineFirstData.build({required T? data, required Failure? error, required bool isDataFromCache}) {
    final output = OfflineFirstData(data: data, error: error, isDataFromCache: isDataFromCache);
    return output;
  }

  DataMode get dataMode {
    if (data == null) {
      return error == null ? DataMode.loading : DataMode.error;
    } else {
      if (error != null) return DataMode.successCacheAndError;
      return isDataFromCache ? DataMode.successCache : DataMode.success;
    }
  }

  TopLoadingBarState get topLoadingBarState {
    if (dataMode == DataMode.successCacheAndError && error!.failureType == FailureType.noInternet) return TopLoadingBarState.noNet;
    if (dataMode == DataMode.successCache) return TopLoadingBarState.loading;
    return TopLoadingBarState.normal;
  }
}

enum DiffType { remove, insert }

class DiffEntity extends Equatable {
  final DiffType diffType;
  final int index;

  DiffEntity({required this.index, required this.diffType});

  @override
  List<Object> get props => [index, diffType];
}

class OfflineFirstListData<T> {
  final List<T>? newData;
  final List<T?>? oldData;
  final Failure? error;
  final bool isDataFromCache;

  const OfflineFirstListData({
    required this.newData,
    required this.oldData,
    required this.error,
    required this.isDataFromCache,
  });

  factory OfflineFirstListData.build(
      {required List<T>? newData, required List<T>? oldData, required Failure? error, required bool isDataFromCache}) {
    final output = OfflineFirstListData(newData: newData, oldData: oldData, error: error, isDataFromCache: isDataFromCache);
    return output;
  }

  DataMode get dataMode {
    if (newData == null) {
      return error == null ? DataMode.loading : DataMode.error;
    } else {
      if (error != null) return DataMode.successCacheAndError;
      return isDataFromCache ? DataMode.successCache : DataMode.success;
    }
  }

  List<DiffEntity> getDiffBetweenOldAndNew() {
    if (newData == null || oldData == null) return [];
    List<T> difference = newData!.toSet().difference(oldData!.toSet()).toList();
    return difference
        .mapIndexed((index, element) => DiffEntity(index: index, diffType: newData!.contains(element) ? DiffType.insert : DiffType.remove))
        .toList();
  }

  TopLoadingBarState get topLoadingBarState {
    if (dataMode == DataMode.successCacheAndError && error!.failureType == FailureType.noInternet) return TopLoadingBarState.noNet;
    if (dataMode == DataMode.successCache) return TopLoadingBarState.loading;
    return TopLoadingBarState.normal;
  }
}
