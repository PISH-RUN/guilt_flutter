import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/psp_update_user_state.dart';

import '../../domain/use_cases/psp_main.dart';

class PspUpdateUserCubit extends Cubit<PspUpdateUserState> {
  final PspMain _main;

  PspUpdateUserCubit({
    required PspMain main,
  })  : _main = main,
        super(const PspUpdateUserState.loading());

  Future<void> initialPage(int userId) async {
    emit(const PspUpdateUserState.loading());
    final response = await _main.getUserData(userId);
    response.fold(
      (failure) => emit(PspUpdateUserState.error(failure: failure)),
      (userInfo) => emit(PspUpdateUserState.readyToInput(userInfo: userInfo)),
    );
  }

  Future<void> updateUser(UserInfo user, String token) async {
    emit(const PspUpdateUserState.loadingForSubmit());
    final response = await _main.updateUser(user, token);
    response.fold(
      (failure) => emit(PspUpdateUserState.errorForSubmit(failure: failure)),
      () => emit(const PspUpdateUserState.success()),
    );
  }
}
