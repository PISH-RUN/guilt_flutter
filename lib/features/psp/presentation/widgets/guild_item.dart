import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/pair_text_row.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:qlevar_router/qlevar_router.dart';

const paddingSize = 6.0;

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
                PairTextRow(title: "نام رسته شغلی", value: guild.guild.isic.name),
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
              QR.to('/psp/edit/1436/${guild.guild.id}');
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffE2E8F0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
              child: Text("پیگیری میکنم", style: defaultTextStyle(context, headline: 4).w(FontWeight.w400)),
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
                initialChildSize: 0.65,
                maxChildSize: 0.9,
                minChildSize: 0.65,
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
                            PairTextRow(title: "نام رسته شغلی", value: guild.guild.isic.name),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "نام سازمان", value: guild.guild.organName),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "کد پستی", value: guild.guild.postalCode),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
                            const SizedBox(height: paddingSizeDialog),
                            PairTextRow(title: "آدرس", value: guild.guild.address),
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
