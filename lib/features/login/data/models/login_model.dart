import '../../domain/entities/login.dart';

class LoginModel extends Login {
  final String token;
  LoginModel({
    required this.token,
  }) : super(token: token);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['jwt'],
    );
  }
}
