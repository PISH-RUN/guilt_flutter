import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/map_widget.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/warning_dialog.dart';

class GuildLabelWidget extends StatefulWidget {
  final Guild guild;
  final void Function() onEditPressed;

  const GuildLabelWidget({required this.guild, required this.onEditPressed, Key? key}) : super(key: key);

  @override
  State<GuildLabelWidget> createState() => _GuildLabelWidgetState();
}

class _GuildLabelWidgetState extends State<GuildLabelWidget> {
  final double paddingBetweenTextFiled = 10.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const SizedBox(width: 56.0),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text("اطلاعات کسب و کار", style: defaultTextStyle(context, headline: 3)),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => showEditDialog(context),
                          child: AbsorbPointer(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(Icons.edit, color: Colors.blueGrey, size: 15.0),
                                  const SizedBox(width: 4.0),
                                  Text("ویرایش", style: defaultTextStyle(context, headline: 5).c(Colors.blueGrey)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        labelWidget(context, Icons.store, "نام کسب و کار", widget.guild.title),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(context, Icons.store, "نام ارگان", widget.guild.organName),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(context, Icons.phone, "شماره تلفن صنف", widget.guild.homeTelephone),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(context, Icons.store, "رسته صنفی", widget.guild.isic.name),
                        SizedBox(height: paddingBetweenTextFiled),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: labelWidget(context, Icons.pin_drop_outlined, "استان", widget.guild.province,
                                  headlineDescription: 4, headlineTitle: 5),
                            ),
                            SizedBox(width: paddingBetweenTextFiled),
                            Expanded(
                              child: labelWidget(context, Icons.pin_drop_outlined, "شهرستان", widget.guild.city,
                                  headlineDescription: 4, headlineTitle: 5),
                            ),
                          ],
                        ),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(context, Icons.map, "کد پستی", widget.guild.postalCode),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(context, Icons.pin_drop_outlined, "نشانی کامل", widget.guild.address),
                        SizedBox(height: paddingBetweenTextFiled),
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.4),
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                          ),
                          child: widget.guild.location == null ? const SizedBox() : MapScreenShotWidget(pinLocation: widget.guild.location!),
                        ),
                        SizedBox(height: paddingBetweenTextFiled),
                        const SizedBox(height: 26.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showEditDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => WarningDialog(onResult: (isAccess) {
        if (isAccess) {
          widget.onEditPressed();
        }
      }),
    );
  }

  Widget labelWidget(BuildContext context, IconData icon, String label, String value, {int headlineDescription = 3, int headlineTitle = 4}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Padding(padding: const EdgeInsets.only(bottom: 4.0), child: Icon(icon, color: Colors.grey)),
              const SizedBox(width: 8.0),
              Text("$label:", style: defaultTextStyle(context, headline: headlineTitle).c(Colors.grey)),
            ],
          ),
          const SizedBox(height: 0.0),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              value.isEmpty ? "هنوز وارد نکردید" : value,
              style: defaultTextStyle(context, headline: headlineDescription).c(value.isNotEmpty ? Colors.black : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
