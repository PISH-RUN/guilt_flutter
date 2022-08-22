import '../domain/repositories/login_repository.dart';

abstract class LoginApi {
  bool isUserRegistered();

  void removeToken();
}

class LoginApiImpl extends LoginApi {
  LoginRepository loginRepository;

  LoginApiImpl(this.loginRepository);

  @override
  bool isUserRegistered() => loginRepository.getToken().isNotEmpty;

  @override
  void removeToken() async => loginRepository.saveTokenInStorage("");
}
