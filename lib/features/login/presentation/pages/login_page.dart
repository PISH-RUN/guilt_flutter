import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_role.dart';
import 'package:guilt_flutter/features/login/presentation/widgets/login_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../app_route.dart';
import '../../../../main.dart';
import '../manager/login_cubit.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static Widget wrappedRoute() {
    return BlocProvider(create: (ctx) => GetIt.instance<LoginCubit>(), child: LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return LoginWidget(onSuccess: (userData) {
      GetStorage().write('userData', jsonEncode(userData.toJson()));
      switch (userData.role) {
        case UserRole.psp:
          QR.navigator.replaceAll(redirectPath.isNotEmpty ? redirectPath : 'psp/guildList');
          break;
        case UserRole.user:
          QR.navigator.replaceAll(redirectPath.isNotEmpty ? redirectPath : initPath);
          break;
        case UserRole.admin:
          break;
      }
    });
  }
}
