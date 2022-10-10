import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/update_user_cubit.dart';
import 'package:guilt_flutter/features/profile/presentation/widgets/form_widget.dart';
import 'package:guilt_flutter/features/profile/presentation/widgets/label_widget.dart';
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../commons/failures.dart';
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
  late FormController formController;

  @override
  void initState() {
    formController = FormController();
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
          error: (failure) {
            if (failure.failureType == FailureType.haveNoGuildAndProfile) {
              user = UserInfo.empty();
              return Scaffold(
                body: FormWidget(
                  defaultUser: user!,
                  formController: formController,
                  onSubmit: (user) {
                    BlocProvider.of<UpdateUserCubit>(context).updateUserInfo(user);
                    if (QR.currentPath.contains('signIn/profile')) {
                      QR.navigator.replaceAll(appMode.initPath);
                    } else {
                      this.user = user;
                      setState(() => isEditable = false);
                    }
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => formController.onSubmitButton!(),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.save),
                ),
              );
            }
            return Center(child: Text(failure.message));
          },
          loaded: (userInfo) {
            user ??= userInfo;
            return isEditable
                ? Scaffold(
                    body: FormWidget(
                      key: UniqueKey(),
                      defaultUser: user!,
                      formController: formController,
                      onSubmit: (user) {
                        BlocProvider.of<UpdateUserCubit>(context).updateUserInfo(user);
                        if (QR.currentPath.contains('signIn/profile')) {
                          QR.navigator.replaceAll(appMode.initPath);
                        } else {
                          this.user = user;
                          setState(() => isEditable = false);
                        }
                      },
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => formController.onSubmitButton!(),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.save),
                    ),
                  )
                : LabelWidget(key: UniqueKey(), user: user!, onEditPressed: () => setState(() => isEditable = true));
          },
        );
      },
    ));
  }
}
