import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/login/presentation/manager/login_cubit.dart';
import 'package:guilt_flutter/features/login/presentation/widgets/login_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

class LoginViaUserPage extends StatefulWidget {
  const LoginViaUserPage({Key? key}) : super(key: key);

  @override
  _LoginViaUserPageState createState() => _LoginViaUserPageState();

  static Widget wrappedRoute() {
    return BlocProvider(create: (ctx) => GetIt.instance<LoginCubit>(), child: const LoginViaUserPage());
  }
}

class _LoginViaUserPageState extends State<LoginViaUserPage> {
  @override
  Widget build(BuildContext context) {
    return LoginWidget(onSuccess: (userData) => QR.to('psp/edit/${QR.params['guildId'].toString()}'));
  }
}
