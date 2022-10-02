import 'package:bloc/bloc.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/login/presentation/manager/register_state.dart';
import 'login_cubit.dart';
import '../../domain/usecase/login_main.dart';
import 'login_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final LoginMain _loginMain;

  RegisterCubit({
    required LoginMain loginMain,
  })  : _loginMain = loginMain,
        super(const RegisterState.readyToInput());

  Future<void> registerWithPhoneNumber(String phoneNumber, String nationalCode) async {
    LoginCubit.phoneNumber = getPhoneNumber(phoneNumber) ?? "";
    LoginCubit.nationalCode = nationalCode;

    emit(const RegisterState.loading());
    final response = await _loginMain.registerWithPhoneNumber(phoneNumber: LoginCubit.phoneNumber, nationalCode: LoginCubit.nationalCode);
    response.fold(
      (failure) => emit(RegisterState.error(failure: failure)),
      (_) => emit(const RegisterState.success()),
    );
  }

  Future<void> readyForInputData() async {
    emit(const RegisterState.readyToInput());
  }
}
