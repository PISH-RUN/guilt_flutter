import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'get_user_state.dart';
import '../../domain/use_cases/profile_main.dart';

class GetUserCubit extends Cubit<GetUserState> {
  final ProfileMain _main;

  GetUserCubit({
    required ProfileMain main,
  })  : _main = main,
        super(const GetUserState.loading());

  Future<void> initialPage(UserInfo user) async {
    emit(const GetUserState.loading());
    final response = await _main.getUserInfo(user);
    response.fold(
      (failure) => emit(GetUserState.error(failure: failure)),
      (user) => emit(GetUserState.loaded(user: user)),
    );
  }
}
