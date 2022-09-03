import 'package:get_storage/get_storage.dart';

import '../domain/repositories/login_repository.dart';

abstract class LoginApi {
  bool isUserRegistered();

  Future<void> signOut();

  String getUserId();

  String getUserPhone();
}

class LoginApiImpl extends LoginApi {
  LoginRepository loginRepository;

  LoginApiImpl(this.loginRepository);

  @override
  bool isUserRegistered() => loginRepository.getToken().isNotEmpty;

  @override
  String getUserId() => loginRepository.getUserId();

  @override
  String getUserPhone() => loginRepository.getUserPhone();

  @override
  Future<void> signOut() async => await GetStorage().erase();
}
