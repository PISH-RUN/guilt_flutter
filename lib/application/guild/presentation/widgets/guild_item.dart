import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_cubit.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/pair_text_row.dart';
import 'package:qlevar_router/qlevar_router.dart';

const paddingSize = 6.0;

class GuildItem extends StatelessWidget {
  final Guild guild;

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
                    Text(guild.title, style: defaultTextStyle(context, headline: 3)),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () => QR.to('guild/view/${guild.uuid}'),
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
                PairTextRow(title: "استان", value: guild.province),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "شهرستان", value: guild.city),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "رسته شغلی", value: guild.isic.name),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "نام سازمان", value: guild.organName),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "کد پستی", value: guild.postalCode),
                const SizedBox(height: paddingSize),
                PairTextRow(title: "آدرس", value: guild.address),
                const SizedBox(height: paddingSize),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (guild.isCouponRequested) return;
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
                BlocProvider.of<GuildListCubit>(context).sendRequestForCoupon(context,guild: guild);

              }
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
              child: Text(guild.isCouponRequested ? "درخواست کالابرگ ثبت شد" : "درخواست کالابرگ",
                  style: defaultTextStyle(context, headline: 4).w(FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }
}
