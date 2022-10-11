import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';

part 'psp_update_user_state.freezed.dart';

@freezed
class PspUpdateUserState with _$PspUpdateUserState {
  const factory PspUpdateUserState.loading() = Loading;

  const factory PspUpdateUserState.error({required Failure failure}) = Error;

  const factory PspUpdateUserState.errorForSubmit({required Failure failure}) = ErrorForSubmit;

  const factory PspUpdateUserState.readyToInput({required UserInfo userInfo}) = ReadyToInput;

  const factory PspUpdateUserState.success() = Success;

  const factory PspUpdateUserState.loadingForSubmit() = LoadingForSubmit;
}
