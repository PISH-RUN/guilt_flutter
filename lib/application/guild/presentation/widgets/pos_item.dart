import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class PosItem extends StatelessWidget {
  final Pos pos;

  const PosItem({required this.pos, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 6.0),
        SvgPicture.asset(
          'images/atm.svg',
          height: 50,
          width: 50,
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              pairTextRow(context, "شماره ترمینال", pos.terminalId),
              pairTextRow(context, "psp", pos.psp),
              pairTextRow(context, "شماره حساب", pos.accountNumber),
            ],
          ),
        ),
      ],
    );
  }

  Widget pairTextRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title + ":",
            textAlign: TextAlign.center,
            style: defaultTextStyle(context, headline: 4).c(Colors.black54),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: defaultTextStyle(context, headline: 4),
          ),
        ],
      ),
    );
  }
}
