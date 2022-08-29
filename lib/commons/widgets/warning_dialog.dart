import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class WarningDialog extends StatefulWidget {
  final void Function(bool isSuccess) onResult;

  const WarningDialog({required this.onResult, Key? key}) : super(key: key);

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  void initState() {
    isDialogOpen = true;
    super.initState();
  }

  @override
  void dispose() {
    isDialogOpen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Text("ویرایش", style: defaultTextStyle(context, headline: 3)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      content: Text("آیا مایل به ویرایش اطلاعات می باشید؟", style: defaultTextStyle(context, headline: 5).c(Colors.black.withOpacity(0.7))),
      actions: <Widget>[
        TextButton(
          child: Text("لغو", style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
          onPressed: () {
            isDialogOpen = false;
            Navigator.pop(context, false);
            widget.onResult(false);
          },
        ),
        TextButton(
          child: Text("ثبت", style: defaultTextStyle(context, headline: 5).c(Theme.of(context).primaryColor)),
          onPressed: () async {
            isDialogOpen = false;
            Navigator.pop(context, true);
            widget.onResult(true);
          },
        ),
      ],
    );
  }
}
