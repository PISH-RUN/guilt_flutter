import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/pair_text_row.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp_step.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:qlevar_router/qlevar_router.dart';

const paddingSize = 6.0;

class GuildItem extends StatefulWidget {
  final GuildPsp guild;

  const GuildItem({required this.guild, Key? key}) : super(key: key);

  @override
  State<GuildItem> createState() => _GuildItemState();
}

class _GuildItemState extends State<GuildItem> {
  late GuildPsp guild;

  @override
  void initState() {
    guild = widget.guild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: paddingSize),
                Row(
                  children: <Widget>[
                    Text(guild.guild.title, style: defaultTextStyle(context, headline: 3)),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () => showDetailDialog(context),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        decoration: const BoxDecoration(
                            color: Color(0xffE2E8F0), shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text("مشاهده جزئیات", style: defaultTextStyle(context, headline: 4).c(const Color(0xff0284CA))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: (paddingSize * 2)),
                PairTextRow(title: "استان", value: guild.guild.province),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "شهرستان", value: guild.guild.city),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "رسته شغلی", value: guild.guild.isic.name),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "نام سازمان", value: guild.guild.organName),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "کد پستی", value: guild.guild.postalCode),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "آدرس", value: guild.guild.address),
                const SizedBox(height: paddingSize),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (guild.guildPspStep.isGuildEditable) {
                final phoneResponse = await BlocProvider.of<UpdateStateOfGuildCubit>(context).getUserPhoneNumber(guild.guild.userId);
                QR.to('psp/register/${phoneResponse.getOrElse(() => throw UnimplementedError())}/${guild.guild.id}/');
                return;
              }
              if (guild.guildPspStep.isEnd) {
                return;
              }
              if (guild.guildPspStep.id == 1) {
                showSnakeBar(context, "این کسب و کار به صفحه موارد پیگیری افزوده شد");
              }
              guild = guild.copyWith(guildPspStep: GuildPspStep.values.firstWhere((element) => element.id == (guild.guildPspStep.id + 1)));
              BlocProvider.of<UpdateStateOfGuildCubit>(context).updateStateOfSpecialGuild(guild);
              setState(() {});
            },
            child: Opacity(
              opacity: guild.guildPspStep == GuildPspStep.done ? 0.4 : 1.0,
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xffE2E8F0),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
                ),
                child: Text(guild.guildPspStep == GuildPspStep.done ? guild.guildPspStep.stateTitle : guild.guildPspStep.actionName,
                    style: defaultTextStyle(context, headline: 4).w(FontWeight.w400)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDetailDialog(BuildContext context) {
    const paddingSizeDialog = 14.0;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),
      builder: (BuildContext context) {
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.65,
            child: DraggableScrollableSheet(
                initialChildSize: 0.45,
                maxChildSize: 0.9,
                minChildSize: 0.45,
                expand: false,
                builder: (BuildContext context, ScrollController scrollController) {
                  return ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: paddingSizeDialog),
                            Text(guild.guild.title, style: defaultTextStyle(context, headline: 3)),
                            const SizedBox(height: (paddingSizeDialog * 2)),
                            PairTextRow(title: "استان", value: guild.guild.province),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "شهرستان", value: guild.guild.city),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "رسته شغلی", value: guild.guild.isic.name),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "نام سازمان", value: guild.guild.organName),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "کد پستی", value: guild.guild.postalCode),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ),
        );
      },
    );
  }
}
