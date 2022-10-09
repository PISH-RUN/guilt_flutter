import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
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
                guild = guild.copyWith(guild: guildChanged.copyWith(status: 'confirmed'));
                await BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild, isJustState: false, token: token);
                BlocProvider.of<UpdateStateOfGuildCubit>(context).state.maybeWhen(
                      orElse: () {},
                      error: (failure) => showSnakeBar(context, failure.message),
                      success: () {
                        showSnakeBar(context, "تغییرات با موفقیت اعمال شد");
                        return QR.navigator.replaceAll('psp/followGuilds');
                      },
                    );
              }),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
