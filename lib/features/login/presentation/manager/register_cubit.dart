import 'package:bloc/bloc.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'login_cubit.dart';
import '../../domain/usecase/login_main.dart';
import 'login_state.dart';

class RegisterCubit extends Cubit<LoginState> {
  final LoginMain _loginMain;

  RegisterCubit({
    required LoginMain loginMain,
  })  : _loginMain = loginMain,
        super(const LoginState.readyToInput());

  Future<void> registerWithPhoneNumber(String phoneNumber, String nationalCode) async {
    LoginCubit.phoneNumber = getPhoneNumber(phoneNumber) ?? "";
    LoginCubit.nationalCode = nationalCode;

    emit(const LoginState.loading());
    final response = await _loginMain.registerWithPhoneNumber(phoneNumber: LoginCubit.phoneNumber, nationalCode: LoginCubit.nationalCode);
    response.fold(
      (failure) => emit(LoginState.error(failure: failure)),
      (_) => emit(const LoginState.success()),
    );
  }

  Future<void> readyForInputData() async {
    emit(const LoginState.readyToInput());
  }
}
