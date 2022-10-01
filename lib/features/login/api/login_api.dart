import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_data.dart';

import '../domain/repositories/login_repository.dart';

abstract class LoginApi {
  bool isUserRegistered();

  Future<void> signOut();

  UserData getUserData();
}

class LoginApiImpl extends LoginApi {
  LoginRepository loginRepository;

  LoginApiImpl(this.loginRepository);

  @override
  bool isUserRegistered() => loginRepository.getUserData().token.isNotEmpty;

  @override
  UserData getUserData() => loginRepository.getUserData();

  @override
  Future<void> signOut() async => await GetStorage().erase();
}
