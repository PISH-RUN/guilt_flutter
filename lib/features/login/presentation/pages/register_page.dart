import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/features/login/presentation/manager/register_cubit.dart';
import 'package:guilt_flutter/features/login/presentation/widgets/register_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static Widget wrappedRoute() {
    return BlocProvider(create: (ctx) => GetIt.instance<RegisterCubit>(), child: const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return RegisterWidget(
      phoneNumber: "",
      nationalCode: "",
      onSuccessful: () => QR.to('otp'),
      title: "لطفا اطلاعات خود را وارد کنید",
      isRegisterPspVisible: appMode == AppMode.psp,
    );
  }
}
