import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/all_guilds_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/sign_up_psp_cubit.dart';

import 'data/repositories/psp_repository_impl.dart';
import 'domain/repositories/psp_repository.dart';
import 'domain/use_cases/psp_main.dart';
import 'presentation/manager/update_state_of_guild_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
// Cubit
  sl.registerFactory(() => SignUpPspCubit(main: sl()));
  sl.registerFactory(() => FollowUpGuildsCubit(main: sl()));
  sl.registerFactory(() => AllGuildsCubit(main: sl()));
  sl.registerFactory(() => UpdateStateOfGuildCubit(main: sl()));

// Use cases
  sl.registerLazySingleton(() => PspMain(sl()));

// Repository
  sl.registerLazySingleton<PspRepository>(() => PspRepositoryImpl(remoteDataSource: sl()));
}

Widget getAllGuildsCubit(BuildContext context, Widget child) {
  return BlocProvider<AllGuildsCubit>(
    create: (context) => sl<AllGuildsCubit>(),
    child: child,
  );
}

Widget getUpdateStateOfGuildCubit(BuildContext context, Widget child) {
  return BlocProvider<UpdateStateOfGuildCubit>(
    create: (context) => sl<UpdateStateOfGuildCubit>(),
    child: child,
  );
}
