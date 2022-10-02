import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/login/presentation/manager/register_cubit.dart';
import 'package:guilt_flutter/features/login/presentation/widgets/register_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

class RegisterViaUserPage extends StatefulWidget {
  const RegisterViaUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterViaUserPage> createState() => _RegisterViaUserPageState();

  static Widget wrappedRoute() {
    return BlocProvider(create: (ctx) => GetIt.instance<RegisterCubit>(), child: const RegisterViaUserPage());
  }
}

class _RegisterViaUserPageState extends State<RegisterViaUserPage> {
  late String phoneNumber;
  late int guildId;

  @override
  void initState() {
    phoneNumber = QR.params['phoneNumber'].toString();
    guildId = int.parse(QR.params['guildId'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterWidget(phoneNumber: phoneNumber, nationalCode: "", isLocked: false, onSuccessful: () => QR.to('psp/otp/$guildId'));
  }
}
