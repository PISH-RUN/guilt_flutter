import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';

import '../../../../application/colors.dart';
import '../../../../commons/text_style.dart';
import '../../../../commons/utils.dart';
import '../../../../commons/widgets/loading_widget.dart';
import '../../../../commons/widgets/warning_dialog.dart';
import '../../../login/api/login_api.dart';
import '../../domain/entities/user_info.dart';

class LabelWidget extends StatefulWidget {
  final UserInfo user;
  final void Function() onEditPressed;

  const LabelWidget({required this.user, required this.onEditPressed, Key? key}) : super(key: key);

  @override
  _LabelWidgetState createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  late UserInfo user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 6.0),
        avatarWidget(context),
        const SizedBox(height: 6.0),
        baseInformationWidget(context),
      ],
    );
  }

  Widget avatarWidget(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        height: 140,
        width: 140,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: SizedBox(
          height: 130,
          width: 130,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColor.blue, width: 2)),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: !isUrlValid((user.avatar ?? "").trim())
                  ? const Image(image: AssetImage('images/avatar.png'), fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: user.avatar!.trim(),
                      placeholder: (_, __) => LoadingWidget(size: 50, color: AppColor.blue),
                      errorWidget: (_, __, ___) {
                        return const Image(image: AssetImage('images/avatar.png'), fit: BoxFit.cover);
                      },
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  double paddingBetweenTextFiled = 15.0;

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child:  Column(
                children: <Widget>[
                  Row(
                    children: [
                      const SizedBox(width: 93.0),
                      const Spacer(),
                      Text("اطلاعات شخصی", style: defaultTextStyle(context, headline: 3)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (dialogContext) => WarningDialog(onResult: (isAccess) {
                              if (isAccess) {
                                widget.onEditPressed();
                              }
                            }),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                          ),
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        labelWidget(Icons.person_outline, "نام", user.firstName),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(Icons.person_outline, "نام خانوادگی", user.lastName),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(Icons.person_outline, "نام پدر", user.fatherName),
                        labelWidgetRow(Icons.calendar_month, "تاریخ تولد",
                            [user.birthDate!.day.toString(), monthNames[user.birthDate!.month - 1], user.birthDate!.year.toString()]),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(Icons.pin, "کد ملی", GetIt.instance<LoginApi>().getUserData().nationalCode),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(Icons.pin, "شماره تلفن", GetIt.instance<LoginApi>().getUserData().phoneNumber),
                        SizedBox(height: paddingBetweenTextFiled),
                        labelWidget(Icons.male, "جنسیت", user.gender.persianName),
                        SizedBox(height: paddingBetweenTextFiled),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),

        ],
      ),
    );
  }

  InputDecoration defaultInputDecoration(BuildContext context) {
    return const InputDecoration().copyWith(
      helperText: '',
      helperMaxLines: 1,
      filled: true,
      fillColor: const Color(0xffF2F4F5),
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
      hintStyle: defaultTextStyle(context).c(const Color(0xffA0A8B1)),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 0.0, color: Colors.transparent),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1.3, color: Color(0xffA0A8B1)),
      ),
    );
  }

  Widget labelWidget(IconData icon, String label, String value) {
    return labelWidgetRow(icon, label, [value]);
  }

  Widget labelWidgetRow(IconData icon, String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(icon, color: Colors.grey),
              ),
              const SizedBox(width: 8.0),
              Text(
                "$label:",
                style: defaultTextStyle(context, headline: 4).c(Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              children: values
                  .map((value) => Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          value.isEmpty ? "هنوز وارد نکردید" : value,
                          style: defaultTextStyle(context, headline: 3).c(value.isNotEmpty ? Colors.black : Colors.black54),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
