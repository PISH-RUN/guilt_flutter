import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/all_guilds_cubit.dart';
import 'package:qlevar_router/qlevar_router.dart';

class PspFormPage extends StatefulWidget {
  const PspFormPage({Key? key}) : super(key: key);

  @override
  State<PspFormPage> createState() => _PspFormPageState();

  static Widget wrappedRoute() => BlocProvider(create: (ctx) => GetIt.instance<AllGuildsCubit>(), child: const PspFormPage());
}

class _PspFormPageState extends State<PspFormPage> {
  late int guildId;
  late String token;
  late GuildPsp guild;

  @override
  void initState() {
    guildId = int.parse(QR.params['guildId'].toString());
    token = QR.params['token'].toString();
    guild = BlocProvider.of<AllGuildsCubit>(context).getGuildBuId(guildId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GuildFormWidget(isAddNew: false, guild: guild.guild, isEditable: true, isPsp: true),
          submitButton(context),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return GestureDetector(
      onTap: () => QR.back(),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(18),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: const Color(0xff4ADE80), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
        child: Text("اعمال تغییرات", style: defaultTextStyle(context, headline: 4).c(const Color(0xff166534))),
      ),
    );
  }
}
