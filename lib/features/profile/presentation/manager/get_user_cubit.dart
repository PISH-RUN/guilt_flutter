import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';

import '../../domain/use_cases/profile_main.dart';
import 'get_user_state.dart';

class GetUserCubit extends Cubit<GetUserState> {
  final ProfileMain _main;

  GetUserCubit({
    required ProfileMain main,
  })  : _main = main,
        super(const GetUserState.loading());

  Future<void> initialPage() async {
    emit(const GetUserState.loading());
    final response = await _main.getProfile(GetIt.instance<LoginApi>().getUserId());
    response.fold(
      (failure) => emit(GetUserState.error(failure: failure)),
      (user) => emit(GetUserState.loaded(user: user)),
    );
  }
}
