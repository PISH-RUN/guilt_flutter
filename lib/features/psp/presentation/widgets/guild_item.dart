import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp_step.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';

class GuildItem extends StatelessWidget {
  final GuildPsp guild;

  const GuildItem({required this.guild, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: AutoSizeText(guild.guild.title, style: defaultTextStyle(context, headline: 3), maxLines: 1, minFontSize: 2),
            subtitle: Text(guild.guild.city, style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
            onTap: () {
              // QR.to('guild/${guild.guild.id}').then((v) => BlocProvider.of<GuildListCubit>(context).initialPage(context));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: OurButton(
              onTap: () async {
                isDialogOpen = true;
                final isOK = await showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    title: Text("درخواست کالابرگ", style: defaultTextStyle(context, headline: 3)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    content: Text("اینجانب ضمن تایید اطلاعات خود، توافق خود را جهت استفاده از کالابرگ و رعایت شرایط مربوطه اعلام می دارم.",
                        style: defaultTextStyle(context, headline: 5).c(Colors.black.withOpacity(0.7))),
                    actions: <Widget>[
                      TextButton(
                        child: Text("انصراف", style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
                        onPressed: () {
                          isDialogOpen = false;
                          Navigator.pop(dialogContext, false);
                        },
                      ),
                      TextButton(
                        child: Text("تایید", style: defaultTextStyle(context, headline: 5).c(Theme.of(context).primaryColor)),
                        onPressed: () async {
                          isDialogOpen = false;
                          Navigator.pop(dialogContext, true);
                        },
                      ),
                    ],
                  ),
                ) as bool;
                isDialogOpen = false;
                if (isOK) {
                  BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild.copyWith(guildPspStep: GuildPspStep.processing));
                }
              },
              title: guild.guildPspStep.name,
              isLoading: false,
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
