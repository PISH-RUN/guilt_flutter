import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp_step.dart';
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

  @override
  void initState() {
    guildId = int.parse(QR.params['guildId'].toString());
    token = QR.params['token'].toString();
    guild = BlocProvider.of<FollowUpGuildsCubit>(context).getGuildBuId(guildId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GuildFormWidget(
              isAddNew: false,
              guild: guild.guild,
              isEditable: true,
              isPsp: true,
              onSubmitFormInPsps: (guildChanged) async {
                guild = guild.copyWith(guildPspStep: GuildPspStep.done, guild: guildChanged);
                await BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild, isJustState: false, token: token);
                BlocProvider.of<UpdateStateOfGuildCubit>(context).state.maybeWhen(
                      orElse: () {},
                      error: (failure) => showSnakeBar(context, failure.message),
                      success: () {
                        showSnakeBar(context, "تغییرات با موفقیت اعمال شد");
                        return QR.back();
                      },
                    );
              }),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // guild = guild.copyWith(guildPspStep: GuildPspStep.done);
        await BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild, isJustState: false, token: token);
        BlocProvider.of<UpdateStateOfGuildCubit>(context).state.maybeWhen(
              orElse: () {},
              error: (failure) => showSnakeBar(context, failure.message),
              success: () {
                showSnakeBar(context, "تغییرات با موفقیت اعمال شد");
                return QR.back();
              },
            );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(18),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
        child: Text("اعمال تغییرات و تایید نهایی", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
      ),
    );
  }
}
