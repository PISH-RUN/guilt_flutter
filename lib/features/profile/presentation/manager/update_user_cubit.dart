import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/use_cases/profile_main.dart';
import 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  final ProfileMain _main;

  UpdateUserCubit({
    required ProfileMain main,
  })  : _main = main,
        super(const UpdateUserState.readyToInput());

  Future<void> updateUserInfo(UserInfo user) async {
    emit(const UpdateUserState.loading());
    final response = await _main.updateUserInfo(user);
    response.fold(
      (failure) => emit(UpdateUserState.error(failure: failure)),
      () => emit(const UpdateUserState.success()),
    );
  }

  Future<void> changeAvatar(UserInfo user, XFile avatar) async {
    emit(const UpdateUserState.loading());
    final response = await _main.changeAvatar( avatar);
    response.fold(
      (failure) => emit(UpdateUserState.error(failure: failure)),
      () => emit(const UpdateUserState.success()),
    );
  }
}
