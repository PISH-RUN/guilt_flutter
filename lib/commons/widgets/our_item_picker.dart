import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class OurItemPicker extends StatefulWidget {
  final IconData? icon;
  final String hint;
  final String currentText;
  final TextEditingController controller;
  final List<String>? items;
  final bool isColorBlue;
  final void Function(String value)? onChanged;
  final Future<List<String>> Function()? onFillParams;

  const OurItemPicker(
      {required this.hint,
      this.icon,
      this.isColorBlue = false,
      this.onChanged,
      this.onFillParams,
      required this.controller,
      this.currentText = "",
      required this.items,
      Key? key})
      : super(key: key);

  @override
  State<OurItemPicker> createState() => _OurItemPickerState();
}

class _OurItemPickerState extends State<OurItemPicker> {
  List<String> items = [];

  @override
  void initState() {
    super.initState();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    widget.controller.text = widget.currentText;
    return GestureDetector(
      onTap: () async {
        focusNode.requestFocus();
        focusNode.unfocus();
        items = widget.onFillParams == null ? widget.items ?? [] : (await widget.onFillParams!());
        showDialog(
          context: context,
          builder: (_) => _showAlertDialogWithButtons(
            context,
          ),
        );
      },
      child: AbsorbPointer(
        child: TextField(
            style: defaultTextStyle(context),
            controller: widget.controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: widget.hint,
              prefixIcon: widget.icon == null ? null : Icon(widget.icon),
              helperText: ''
            ),

        ),
      ),
    );
  }

  Widget _showAlertDialogWithButtons(BuildContext context) {
    return Center(
      child: SizedBox(
        height: items.length * 80.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Card(
            elevation: 0.0,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  if (items[index] == widget.controller.text) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.controller.text = items[index];
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              items[index],
                              style: defaultTextStyle(context, headline: 4).c(Colors.white),
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.resolveWith((states) {
                            return const BorderSide(color: AppColor.blue, width: 2);
                          }),
                          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                            return RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));
                          }),
                        ),
                        onPressed: () {
                          widget.controller.text = items[index];
                          if (widget.onChanged != null) widget.onChanged!(items[index]);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            items[index],
                            style: defaultTextStyle(context, headline: 4).c(AppColor.blue),
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
