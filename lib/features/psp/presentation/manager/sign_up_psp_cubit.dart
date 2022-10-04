import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/psp/domain/entities/psp_user.dart';
import 'package:guilt_flutter/features/psp/domain/use_cases/psp_main.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/sign_up_psp_state.dart';

class SignUpPspCubit extends Cubit<SignUpPspState> {
  final PspMain _main;

  SignUpPspCubit({
    required PspMain main,
  })  : _main = main,
        super(const SignUpPspState.readyToInput());

  Future<void> signUpPsp(PspUser pspUser) async {
    emit(const SignUpPspState.loading());
    final response = await _main.signUpPsp(pspUser);
    response.fold(
      (failure) => emit(SignUpPspState.error(failure: failure)),
      () => emit(const SignUpPspState.success()),
    );
  }
}
