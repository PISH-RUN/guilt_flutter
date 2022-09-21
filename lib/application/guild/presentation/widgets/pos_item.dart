import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/pair_text_row.dart';

class PosItem extends StatelessWidget {
  final Pos pos;
  final void Function() onDeletePressed;

  const PosItem({required this.pos, required this.onDeletePressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: <Widget>[
            const SizedBox(width: 6.0),
            SvgPicture.asset('images/atm.svg', height: 50, width: 50),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 6.0),
                  PairTextRow(title: "شماره ترمینال", value: pos.terminalId),
                  const SizedBox(height: 12.0),
                  PairTextRow(title: "psp", value: pos.psp),
                  const SizedBox(height: 12.0),
                  PairTextRow(title: "شماره حساب", value: pos.accountNumber),
                  const SizedBox(height: 6.0),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            GestureDetector(
              onTap: () => onDeletePressed(),
              child: Container(
                width: 50,
                height: 35,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xffFEF2F2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text("حذف", style: defaultTextStyle(context, headline: 6).c(const Color(0xffB91C1C)))],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
