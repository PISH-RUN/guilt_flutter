import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/features/profile/presentation/widgets/form_widget.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/psp_update_user_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/psp_update_user_state.dart';
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../commons/widgets/loading_widget.dart';

class PspProfileEditPage extends StatefulWidget {
  const PspProfileEditPage({Key? key}) : super(key: key);

  @override
  _PspProfileEditPageState createState() => _PspProfileEditPageState();

  static Widget wrappedRoute() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PspUpdateUserCubit>(create: (BuildContext context) => GetIt.instance<PspUpdateUserCubit>()),
      ],
      child: const PspProfileEditPage(),
    );
  }
}

class _PspProfileEditPageState extends State<PspProfileEditPage> {
  late FormController formController;
  bool isLoadingSubmit = false;

  @override
  void initState() {
    formController = FormController();
    isLoadingSubmit = false;
    BlocProvider.of<PspUpdateUserCubit>(context).initialPage(int.parse(QR.params['userId'].toString()), QR.params['token'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<PspUpdateUserCubit, PspUpdateUserState>(
      listener: (context, state) {
        isLoadingSubmit = false;
        state.maybeWhen(
          orElse: () {},
          loadingForSubmit: () => isLoadingSubmit = true,
          success: () {
            QR.to('psp/editGuild/${QR.params['token'].toString()}/${QR.params['guildId'].toString()}');
          },
        );
      },
      builder: (context, state) {
        return state.when(
          loading: () => LoadingWidget(),
          error: (failure) => Center(child: Text(failure.message)),
          readyToInput: (userInfo) => SingleChildScrollView(
            child: Column(
              children: [
                FormWidget(
                  key: UniqueKey(),
                  defaultUser: userInfo,
                  isAvatarVisible: false,
                  formController: formController,
                  onSubmit: (user) => BlocProvider.of<PspUpdateUserCubit>(context).updateUser(user, QR.params['token'].toString()),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => formController.onSubmitButton!(),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.all(18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
                    child: Text("مرحله بعد", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          success: () => const SizedBox(),
          errorForSubmit: (failure) => Center(child: Text(failure.message)),
          loadingForSubmit: () => const SizedBox(),
        );
      },
    ));
  }
}
