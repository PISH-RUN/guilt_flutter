import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/our_text_field.dart';

class OurItemPicker extends StatefulWidget {
  final IconData? icon;
  final String hint;
  final String currentText;
  final TextEditingController controller;
  final List<String>? items;
  final int headlineSize;
  final void Function(String value)? onChanged;
  final Future<List<String>> Function()? onFillParams;

  const OurItemPicker({
    required this.hint,
    this.icon,
    this.onChanged,
    this.headlineSize = 4,
    this.onFillParams,
    required this.controller,
    this.currentText = "",
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  State<OurItemPicker> createState() => _OurItemPickerState();
}

class _OurItemPickerState extends State<OurItemPicker> {
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
        final items = widget.onFillParams == null ? widget.items ?? [] : (await widget.onFillParams!());
        isDialogOpen = true;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                isDialogOpen = false;
                return true;
              },
              child: ShowAlertDialogWithButtons(
                context: context,
                controller: widget.controller,
                hint: widget.hint,
                items: items,
                onChanged: widget.onChanged,
                currentText: widget.currentText,
                icon: widget.icon,
                onFillParams: widget.onFillParams,
              ),
            );
          },
        );
      },
      child: AbsorbPointer(
          child: OurTextField(
        title: widget.hint,
        textFormField: TextFormField(
          style: defaultTextStyle(context, headline: widget.headlineSize).c(const Color(0xff2F3135)),
          controller: widget.controller,
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          decoration: defaultInputDecoration(context).copyWith(
            hintText: widget.hint,
            hintStyle: defaultTextStyle(context, headline: widget.headlineSize).c(const Color(0xffaaadb4)),
            contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
            prefixIcon: widget.icon == null ? null : Icon(widget.icon),
            helperText: '',
          ),
          validator: (value) {
            if (value == null) {
              return null;
            }
            if (value.isEmpty) {
              return "این فیلد نباید خالی باشد";
            }
            return null;
          },
        ),
      )),
    );

    // return Text(
    //   "Hello",
    //   textAlign: TextAlign.center,
    //   style: defaultTextStyle(context, headline: 4),
    // );
  }
}

class ShowAlertDialogWithButtons extends StatefulWidget {
  final BuildContext context;
  final IconData? icon;
  final String hint;
  final String currentText;
  final TextEditingController controller;
  final List<String> items;
  final bool isColorBlue;
  final void Function(String value)? onChanged;
  final Future<List<String>> Function()? onFillParams;

  const ShowAlertDialogWithButtons({
    required this.context,
    required this.hint,
    this.icon,
    this.isColorBlue = false,
    this.onChanged,
    this.onFillParams,
    required this.controller,
    this.currentText = "",
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  _ShowAlertDialogWithButtonsState createState() => _ShowAlertDialogWithButtonsState();
}

class _ShowAlertDialogWithButtonsState extends State<ShowAlertDialogWithButtons> {
  String searchText = '';
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemsMatch = widget.items.where((element) => element.contains(searchText)).toList();
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: 320,
          height: (widget.items.length * 80.0) + 60,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Card(
              elevation: 0.0,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.search, color: AppColor.blue, size: 25.0),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            onChanged: (value) {
                              searchText = value;
                              setState(() {});
                            },
                            style: defaultTextStyle(context).c(Colors.black87),
                            cursorWidth: 0.2,
                            maxLines: 1,
                            minLines: 1,
                            decoration: InputDecoration(
                              // enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                              // focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                              hintText: 'جستجو ...',
                              hintStyle: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemCount: itemsMatch.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (itemsMatch[index] == widget.controller.text) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.controller.text = itemsMatch[index];
                                  isDialogOpen = false;
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      itemsMatch[index],
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
                                  widget.controller.text = itemsMatch[index];
                                  if (widget.onChanged != null) widget.onChanged!(itemsMatch[index]);
                                  isDialogOpen = false;
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(
                                    itemsMatch[index],
                                    style: defaultTextStyle(context, headline: 4).c(AppColor.blue),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
