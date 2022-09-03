import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'api/login_api.dart';
import 'data/repositories/login_repository_impl.dart';
import 'domain/repositories/login_repository.dart';
import 'domain/usecase/login_main.dart';
import 'presentation/manager/login_cubit.dart';
import 'presentation/manager/register_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Apis
  sl.registerLazySingleton<LoginApi>(() => LoginApiImpl(sl()));

  // Cubit
  sl.registerFactory(() => LoginCubit(loginMain: sl()));
  sl.registerFactory(() => RegisterCubit(loginMain: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginMain(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(dataSource: sl(), readDataFromLocal: (key) => GetStorage().read<String>(key) ?? '',
    writeDataToLocal: GetStorage().write));


}
