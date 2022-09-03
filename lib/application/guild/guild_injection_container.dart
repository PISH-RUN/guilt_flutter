import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/application/guild/api/guild_api.dart';
import 'package:guilt_flutter/application/guild/data/repositories/guild_local_repository_impl.dart';
import 'package:guilt_flutter/application/guild/data/repositories/guild_remote_repository_impl.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_local_repository.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/application/guild/domain/usecases/guild_main.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_cubit.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Apis
  sl.registerLazySingleton<GuildApi>(() => GuildApi(guildRemoteRepository: sl()));

  // Cubit
  sl.registerFactory(() => GuildCubit(main: sl()));
  sl.registerFactory(() => GuildListCubit(main: sl()));

  // Use cases
  sl.registerLazySingleton(() => GuildMain(sl()));

  // Repository
  sl.registerLazySingleton<GuildRemoteRepository>(() => GuildRemoteRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<GuildLocalRepository>(() => GuildLocalRepositoryImpl(
        hasData: GetStorage().hasData,
        readData: (key) => GetStorage().read<String>(key) ?? '',
        writeData: GetStorage().write,
      ));
}
