import '../domain/repositories/login_repository.dart';

abstract class LoginApi {
  bool isUserRegistered();

  void signOut();

  String getUserId();
}

class LoginApiImpl extends LoginApi {
  LoginRepository loginRepository;

  LoginApiImpl(this.loginRepository);

  @override
  bool isUserRegistered() => loginRepository.getToken().isNotEmpty;

  @override
  String getUserId() => loginRepository.getUserId();

  @override
  void signOut() async => loginRepository.saveTokenInStorage("");
}
