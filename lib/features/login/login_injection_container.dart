import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/commons/data/data_source/local_storage_data_source.dart';
import 'package:guilt_flutter/commons/data/data_source/local_storage_data_source_impl.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source_impl.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:http/http.dart' as http;
import 'api/login_api.dart';
import 'data/repositories/login_repository_impl.dart';
import 'domain/repositories/login_repository.dart';
import 'domain/usecase/login_main.dart';
import 'presentation/manager/login_cubit.dart';
import 'presentation/manager/register_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubit
  sl.registerFactory(() => LoginCubit(loginMain: sl()));
  sl.registerFactory(() => RegisterCubit(loginMain: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginMain(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(dataSource: sl(), localStorageDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(client: http.Client(), isInternetEnable: isInternetEnable, localStorageDataSource: sl()));
  sl.registerLazySingleton<LocalStorageDataSource>(() => LocalStorageDataSourceImpl(
      read: GetStorage().read, write: GetStorage().write, getMillisecondsSinceEpoch: () => DateTime.now().millisecondsSinceEpoch));

  //Apis
  sl.registerLazySingleton<LoginApi>(() => LoginApiImpl(sl()));
}
