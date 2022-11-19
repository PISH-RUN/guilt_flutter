import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';

class AddPoseWidget extends StatelessWidget {
  final void Function(Pos pos) addedPose;

  const AddPoseWidget({required this.addedPose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: DottedBorder(
        color: const Color(0xff4ADE80),
        strokeWidth: 2,
        padding: EdgeInsets.zero,
        dashPattern: const [6, 6],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: GestureDetector(
          onTap: () async {
            GlobalKey<FormState> formKeyDialog = GlobalKey();
            TextEditingController pspController = TextEditingController();
            TextEditingController terminalController = TextEditingController();
            TextEditingController accountController = TextEditingController();
            isDialogOpen = true;
            await showDialog(
              context: context,
              builder: (context) => Builder(builder: (context) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  content: SingleChildScrollView(
                    child: Form(
                      key: formKeyDialog,
                      onWillPop: () async => true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            style: defaultTextStyle(context),
                            controller: terminalController,
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.end,
                            decoration: defaultInputDecoration(context).copyWith(
                              labelText: "شماره ترمینال:",
                              hintTextDirection: TextDirection.ltr,
                              contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                            ),
                            validator: (value) => posValidatorCheck(value),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            style: defaultTextStyle(context),
                            controller: pspController,
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.end,
                            decoration: defaultInputDecoration(context).copyWith(
                              labelText: "psp:",
                              hintTextDirection: TextDirection.ltr,
                              contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                            ),
                            validator: (value) => posValidatorCheck(value),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            style: defaultTextStyle(context),
                            controller: accountController,
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.end,
                            decoration: defaultInputDecoration(context).copyWith(
                              labelText: "شماره حساب:",
                              hintTextDirection: TextDirection.ltr,
                              contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                            ),
                            validator: (value) => posValidatorCheck(value),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                  child: OurButton(
                                onTap: () {
                                  isDialogOpen = false;
                                  Navigator.pop(context);
                                },
                                title: "انصراف",
                                isLoading: false,
                                color: Colors.grey,
                              )),
                              const SizedBox(width: 12.0),
                              Expanded(
                                  child: OurButton(
                                onTap: () async {
                                  isDialogOpen = false;
                                  if (!formKeyDialog.currentState!.validate()) {
                                    return;
                                  }
                                  final pos = Pos(
                                    terminalId: terminalController.text,
                                    accountNumber: accountController.text,
                                    psp: pspController.text,
                                  );
                                  addedPose(pos);
                                  Navigator.pop(context);
                                },
                                title: "ثبت",
                                isLoading: false,
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
            isDialogOpen = false;
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xffDCFCE7),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.add, color: Color(0xff166534), size: 25.0),
                const SizedBox(width: 10.0),
                Text("افزودن دستگاه پوز", style: defaultTextStyle(context, headline: 4).c(const Color(0xff166534)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? posValidatorCheck(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return 'این فیلد خالی است';
    return null;
  }
}
