import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';

part 'get_user_state.freezed.dart';

@freezed
class GetUserState with _$GetUserState {
  const factory GetUserState.loading() = Loading;

  const factory GetUserState.error({required Failure failure}) = Error;

  const factory GetUserState.loaded({required UserInfo user}) = Loaded;
}
