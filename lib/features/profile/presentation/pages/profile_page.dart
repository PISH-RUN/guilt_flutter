import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/update_user_cubit.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/update_user_state.dart' as update_user_state;
import 'package:guilt_flutter/features/profile/presentation/widgets/form_widget.dart';
import 'package:guilt_flutter/features/profile/presentation/widgets/label_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../commons/widgets/loading_widget.dart';
import '../../domain/entities/user_info.dart';
import '../manager/get_user_cubit.dart';
import '../manager/get_user_state.dart';

class ProfilePage extends StatefulWidget {
  final bool isEditable;

  const ProfilePage({required this.isEditable, Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

  static Widget wrappedRoute(bool isEditable) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdateUserCubit>(create: (BuildContext context) => GetIt.instance<UpdateUserCubit>()),
        BlocProvider<GetUserCubit>(create: (BuildContext context) => GetIt.instance<GetUserCubit>()),
      ],
      child: ProfilePage(isEditable: isEditable),
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  UserInfo? user;
  late bool isEditable;
  late FormProfileController formController;

  @override
  void initState() {
    formController = FormProfileController();
    isEditable = widget.isEditable;
    BlocProvider.of<GetUserCubit>(context).initialPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GetUserCubit, GetUserState>(
      builder: (context, state) {
        return state.when(
          loading: () => LoadingWidget(),
          error: (failure) => Center(child: Text(failure.message)),
          loaded: (userInfo) {
            user ??= userInfo;
            return isEditable
                ? Scaffold(
                    body: FormWidget(
                      key: UniqueKey(),
                      defaultUser: user!,
                      formController: formController,
                    ),
                    floatingActionButton: BlocBuilder<UpdateUserCubit, update_user_state.UpdateUserState>(
                      builder: (context, state) {
                        return FloatingActionButton(
                          onPressed: () async {
                            final user = formController.onSubmitButton!();
                            if (user == null) return;
                            await BlocProvider.of<UpdateUserCubit>(context).updateUserInfo(user);
                            if (QR.currentPath.contains('signIn/profile')) {
                              QR.navigator.replaceAll(appMode.initPath);
                            } else {
                              this.user = user;
                              setState(() => isEditable = false);
                            }
                          },
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          child: state is update_user_state.Loading ? LoadingWidget(size: 16, color: Colors.white) : const Icon(Icons.save),
                        );
                      },
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        LabelWidget(key: UniqueKey(), user: user!, onEditPressed: () => setState(() => isEditable = true)),
                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () async {
                            await GetIt.instance<LoginApi>().signOut();
                            QR.navigator.replaceAll(appMode.initPath);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(1, 1),
                                )
                              ],
                            ),
                            child: Text(
                              "???????? ???? ???????? ????????????",
                              style: defaultTextStyle(context, headline: 4).c(Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        );
      },
    ));
  }
}
