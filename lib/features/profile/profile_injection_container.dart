import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'api/profile_api.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/use_cases/profile_main.dart';
import 'presentation/manager/get_user_cubit.dart';
import 'presentation/manager/update_user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Api
  sl.registerFactory(() => ProfileApi(sl()));

  // Cubit
  sl.registerFactory(() => GetUserCubit(main: sl()));
  sl.registerFactory(() => UpdateUserCubit(main: sl()));

  // Use cases
  sl.registerLazySingleton(() => ProfileMain(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remoteDataSource: sl()));
}

Widget getGetUserCubit(BuildContext context, Widget child) {
  return BlocProvider<GetUserCubit>(
    create: (context) => sl<GetUserCubit>(),
    child: child,
  );
}

Widget getUpdateUserCubit(BuildContext context, Widget child) {
  return BlocProvider<UpdateUserCubit>(
    create: (context) => sl<UpdateUserCubit>(),
    child: child,
  );
}
