import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/utils.dart';
import '../../domain/usecase/login_main.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginMain _loginMain;

  LoginCubit({
    required LoginMain loginMain,
  })  : _loginMain = loginMain,
        super(const LoginState.readyToInput());

  static String phoneNumber = "";
  static String nationalCode = "";

  Future<void> loginWithOneTimePassword(String verifyCode) async {
    emit(const LoginState.loading());
    final response = await _loginMain.loginWithOtp(phoneNumber: LoginCubit.phoneNumber, password: replaceFarsiNumber(verifyCode));
    response.fold(
      (failure) => emit(LoginState.error(failure: failure)),
      (_) => emit(const LoginState.success()),
    );
  }

  Future<void> readyForInputData() async {
    emit(const LoginState.readyToInput());
  }

  Future<Either<Failure, bool>> resendVerifyCode() async {
    return await _loginMain.resendVerifyCode(phoneNumber: LoginCubit.phoneNumber, nationalCode: LoginCubit.nationalCode);
  }
}
