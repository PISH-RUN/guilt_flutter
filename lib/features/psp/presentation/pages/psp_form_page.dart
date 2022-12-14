import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/poses_list_widget.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:qlevar_router/qlevar_router.dart';

class PspFormPage extends StatefulWidget {
  const PspFormPage({Key? key}) : super(key: key);

  @override
  State<PspFormPage> createState() => _PspFormPageState();

  static Widget wrappedRoute() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FollowUpGuildsCubit>(create: (BuildContext context) => GetIt.instance<FollowUpGuildsCubit>()),
        BlocProvider<UpdateStateOfGuildCubit>(create: (BuildContext context) => GetIt.instance<UpdateStateOfGuildCubit>()),
      ],
      child: const PspFormPage(),
    );
  }
}

class _PspFormPageState extends State<PspFormPage> {
  late int guildId;
  late String token;
  late GuildPsp guild;
  bool isCouponRequested = false;
  List<Pos> posList = [];

  @override
  void initState() {
    guildId = int.parse(QR.params['guildId'].toString());
    token = QR.params['token'].toString();
    guild = BlocProvider.of<FollowUpGuildsCubit>(context).getGuildById(guildId);
    isCouponRequested = guild.guild.isCouponRequested;
    posList = guild.guild.poses;
    super.initState();
  }

  final FormController formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GuildFormWidget(
              defaultGuild: guild.guild,
              formController: formController,
            ),
            const SizedBox(height: 20.0),
            PosesListWidget(
              posesList: posList,
              addedNewPose: (pos) async {
                posList = [...posList, pos];
                setState(() {});
              },
              deletedOnePose: (pos) async {
                posList.remove(pos);
                setState(() {});
              },
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => setState(() => isCouponRequested = !isCouponRequested),
              child: Opacity(
                opacity: isCouponRequested ? 0.6 : 1.0,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCouponRequested ? Colors.green : Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    boxShadow: simpleShadow(color: isCouponRequested ? Colors.green : Colors.blue),
                  ),
                  child: Text(isCouponRequested ? "?????????????? ?????????????? ???????? ????" : "?????????????? ?????????????? ???????? ?????? ?????? ?? ??????",
                      style: defaultTextStyle(context, headline: 4).c(Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            submitButton(context),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  bool isLoadingSubmitWithOutConfirmed = false;
  bool isLoadingSubmitWithConfirmed = false;

  Widget submitButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _showModalForSubmit(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(18),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
        child: Text("?????????? ??????????????", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
      ),
    );
  }

  bool isConfirmed = false;

  Future<void> _showModalForSubmit(BuildContext outerContext) async {
    await showModalBottomSheet<void>(
      context: outerContext,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),
      builder: (BuildContext _) {
        return BlocProvider(
          create: (_) => GetIt.instance<UpdateStateOfGuildCubit>(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Container(
              height: 200.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(3, 3),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatefulBuilder(
                    builder: (context,setState) {
                      return GestureDetector(
                        onTap: () async {
                          isConfirmed = false;
                          final guildChanged = formController.onSubmitButton!();
                          if (guildChanged == null) {
                            showSnakeBar(context, FORM_HAS_ERROR);
                            return;
                          }
                          setState(() => isLoadingSubmitWithOutConfirmed = true);
                          guild = guild.copyWith(
                              guild: guildChanged.copyWith(status: 'waiting_confirmation', isCouponRequested: isCouponRequested, poses: posList));
                          await BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild, isJustState: false, token: token);
                          BlocProvider.of<UpdateStateOfGuildCubit>(context).state.maybeWhen(
                                orElse: () {},
                                error: (failure) => showSnakeBar(context, failure.message),
                                success: () {
                                  showSnakeBar(context, "?????????????? ???? ???????????? ?????????? ????");
                                  QR.navigator.replaceAll('psp/followGuilds');
                                },
                              );
                          setState(() => isLoadingSubmitWithOutConfirmed = false);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          padding: const EdgeInsets.all(18),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: AppColor.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: isLoadingSubmitWithOutConfirmed
                              ? LoadingWidget(color: AppColor.blue, size: 20)
                              : Text("?????????? ?????????????? ???????? ?????????? ??????????", style: defaultTextStyle(context, headline: 4).c(AppColor.blue)),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 25.0),
                  StatefulBuilder(
                      builder: (context,setState) {
                      return GestureDetector(
                        onTap: () async {
                          final guildChanged = formController.onSubmitButton!();
                          if (guildChanged == null) {
                            showSnakeBar(context, FORM_HAS_ERROR);
                            return;
                          }
                          setState(() => isLoadingSubmitWithConfirmed = true);
                          guild = guild.copyWith(guild: guildChanged.copyWith(status: 'confirmed', isCouponRequested: isCouponRequested, poses: posList));
                          await BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild, isJustState: false, token: token);
                          BlocProvider.of<UpdateStateOfGuildCubit>(context).state.maybeWhen(
                                orElse: () {},
                                error: (failure) => showSnakeBar(context, failure.message),
                                success: () {
                                  showSnakeBar(context, "?????????????? ???? ???????????? ?????????? ????");
                                  return QR.navigator.replaceAll('psp/followGuilds');
                                },
                              );
                          setState(() => isLoadingSubmitWithConfirmed = false);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          padding: const EdgeInsets.all(18),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
                          child: isLoadingSubmitWithConfirmed
                              ? LoadingWidget(color: Colors.white, size: 20)
                              : Text("?????????? ?????????????? ?? ?????????? ??????????", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
