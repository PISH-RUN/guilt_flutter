import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_cubit.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_state.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/poses_list_widget.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/get_user_cubit.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/get_user_state.dart' as get_user_state;
import 'package:guilt_flutter/features/profile/presentation/manager/update_user_cubit.dart';
import 'package:guilt_flutter/features/profile/presentation/widgets/form_widget.dart';
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

class GuildsFormFirstTime extends StatefulWidget {
  const GuildsFormFirstTime({Key? key}) : super(key: key);

  @override
  State<GuildsFormFirstTime> createState() => _GuildsFormFirstTimeState();

  static Widget wrappedRoute() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdateUserCubit>(create: (BuildContext context) => GetIt.instance<UpdateUserCubit>()),
        BlocProvider<GetUserCubit>(create: (BuildContext context) => GetIt.instance<GetUserCubit>()),
        BlocProvider<GuildListCubit>(create: (BuildContext context) => GetIt.instance<GuildListCubit>()),
      ],
      child: const GuildsFormFirstTime(),
    );
  }
}

class _GuildsFormFirstTimeState extends State<GuildsFormFirstTime> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GuildListCubit>(context).initialPage(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GuildListCubit, GuildListState>(
          builder: (context, state) {
            return state.when(
              loading: () => LoadingWidget(),
              error: (failure) => Center(child: Text(failure.message)),
              empty: () => const SizedBox(),
              loaded: (guildList) => Loaded(guildList: guildList),
            );
          },
        ),
      ),
    );
  }
}

class Loaded extends StatefulWidget {
  final List<Guild> guildList;

  const Loaded({required this.guildList, Key? key}) : super(key: key);

  @override
  _LoadedState createState() => _LoadedState();
}

class _LoadedState extends State<Loaded> {
  int index = -1;
  FormProfileController formProfileController = FormProfileController();
  FormController formController = FormController();
  bool isLoadingSubmit = false;

  @override
  void initState() {
    index = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (index >= widget.guildList.length) {
      QR.navigator.replaceAll(appMode.initPath);
      return const SizedBox();
    }
    List<Pos> posList = index >= 0 ? widget.guildList[index].poses : [];
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: index >= 0
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GuildFormWidget(key: UniqueKey(), defaultGuild: widget.guildList[index], formController: formController),
                      const SizedBox(height: 10.0),
                      PosesListWidget(posesList: posList, addedNewPose: (pos) => posList.add(pos), deletedOnePose: (pos) => posList.remove(pos)),
                    ],
                  )
                : LoadedForProfile(formProfileController: formProfileController),
          ),
          StatefulBuilder(builder: (context, setState) {
            return GestureDetector(
              onTap: () async {
                setState(() => isLoadingSubmit = true);
                if (index >= 0) {
                  var guildChanged = formController.onSubmitButton!();
                  if (guildChanged == null) {
                    showSnakeBar(context, FORM_HAS_ERROR);
                    setState(() => isLoadingSubmit = false);
                    return;
                  }
                  guildChanged = guildChanged.copyWith(poses: posList);
                  await BlocProvider.of<GuildListCubit>(context).saveGuild(guildChanged);
                  setState(() => isLoadingSubmit = false);
                } else {
                  final user = formProfileController.onSubmitButton!();
                  if (user == null) {
                    setState(() => isLoadingSubmit = false);
                    return;
                  }
                  await BlocProvider.of<UpdateUserCubit>(context).updateUserInfo(user);
                  setState(() => isLoadingSubmit = false);
                }
                setState(() => isLoadingSubmit = false);
                nextPage();
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(18),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
                child: isLoadingSubmit
                    ? LoadingWidget(color: Colors.white, size: 20)
                    : Text("ثبت تغییرات و مشاهده کسب و کار بعدی", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
              ),
            );
          }),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }

  void nextPage() => setState(() => index++);
}

class LoadedForProfile extends StatefulWidget {
  final FormProfileController formProfileController;

  const LoadedForProfile({required this.formProfileController, Key? key}) : super(key: key);

  @override
  _LoadedForProfileState createState() => _LoadedForProfileState();
}

class _LoadedForProfileState extends State<LoadedForProfile> {
  @override
  void initState() {
    BlocProvider.of<GetUserCubit>(context).initialPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserCubit, get_user_state.GetUserState>(
      builder: (context, state) {
        Logger().wtf("info=> ${state.toString()} ");
        return state.when(
          loading: () => LoadingWidget(),
          error: (failure) => Center(child: Text(failure.message)),
          loaded: (userInfo) => FormWidget(
            key: UniqueKey(),
            defaultUser: userInfo,
            formController: widget.formProfileController,
          ),
        );
      },
    );
  }
}
