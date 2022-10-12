import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:logger/logger.dart';
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

  @override
  void initState() {
    guildId = int.parse(QR.params['guildId'].toString());
    token = QR.params['token'].toString();
    guild = BlocProvider.of<FollowUpGuildsCubit>(context).getGuildBuId(guildId);
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
              onSubmit: (guildChanged) async {
                guild = guild.copyWith(guild: guildChanged.copyWith(status: isConfirmed ? 'confirmed' : 'waiting_confirmation'));
                await BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild, isJustState: false, token: token);
                BlocProvider.of<UpdateStateOfGuildCubit>(context).state.maybeWhen(
                      orElse: () {},
                      error: (failure) => showSnakeBar(context, failure.message),
                      success: () {
                        showSnakeBar(context, "تغییرات با موفقیت اعمال شد");
                        return QR.navigator.replaceAll('psp/followGuilds');
                      },
                    );
              },
              formController: formController,
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
        await _showModalForSubmit();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(18),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
        child: Text("اعمال تغییرات", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
      ),
    );
  }

  bool isConfirmed = false;

  Future<void> _showModalForSubmit() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),
      builder: (BuildContext context) {
        return Padding(
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
                GestureDetector(
                  onTap: () async {
                    isConfirmed = false;
                    if (!formController.onSubmitButton!()) {
                      showSnakeBar(context, "فرم شما ایراد دارد"); //todo replace with good sentence
                      return;
                    }
                    setState(() => isLoadingSubmitWithOutConfirmed = true);
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
                        ? LoadingWidget(color: Colors.white, size: 20)
                        : Text("اعمال تغییرات بدون تایید نهایی", style: defaultTextStyle(context, headline: 4).c(AppColor.blue)),
                  ),
                ),
                const SizedBox(height: 25.0),
                GestureDetector(
                  onTap: () async {
                    isConfirmed = true;
                    if (!formController.onSubmitButton!()) {
                      showSnakeBar(context, "فرم شما ایراد دارد"); //todo replace with good sentence
                      return;
                    }
                    setState(() => isLoadingSubmitWithConfirmed = true);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.all(18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
                    child: isLoadingSubmitWithConfirmed
                        ? LoadingWidget(color: Colors.white, size: 20)
                        : Text("اعمال تغییرات و تایید نهایی", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
