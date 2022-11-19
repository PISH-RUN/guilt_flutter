import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/commons/widgets/our_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../application/colors.dart';
import '../../../../commons/fix_rtl_flutter_bug.dart';
import '../../../../commons/text_style.dart';
import '../../../../commons/utils.dart';
import '../../../../commons/widgets/loading_widget.dart';
import '../../../../commons/widgets/simple_snake_bar.dart';
import '../../../login/api/login_api.dart';
import '../../domain/entities/gender_type.dart';
import '../../domain/entities/user_info.dart';
import '../manager/update_user_cubit.dart';

class FormWidget extends StatefulWidget {
  final UserInfo defaultUser;
  final bool isAvatarVisible;
  final FormController formController;
  final void Function(UserInfo user) onSubmit;

  const FormWidget({required this.defaultUser, required this.formController, required this.onSubmit, this.isAvatarVisible = true, Key? key})
      : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  late UserInfo user;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController fatherNameController;
  late TextEditingController phoneController;
  late TextEditingController nationalCodeController;
  late Gender gender;
  final GlobalKey<FormState> formKey = GlobalKey();
  String imagePath = '';

  @override
  void initState() {
    user = widget.defaultUser;
    initialTextEditingController();
    widget.formController.onSubmit = onSubmit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: isProgressAvatarHide ? 0.0 : 1.0,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), minHeight: 4.0),
            ),
            const SizedBox(height: 6.0),
            if (widget.isAvatarVisible) avatarWidget(context),
            const SizedBox(height: 6.0),
            baseInformationWidget(context),
          ],
        ),
      ),
    );
  }

  bool onSubmit() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    formKey.currentState!.save();
    widget.onSubmit(user);
    return true;
  }

  bool isProgressAvatarHide = true;

  double paddingBetweenTextFiled = 15.0;

  Widget avatarWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        setState(() => isProgressAvatarHide = false);
        final response = await BlocProvider.of<UpdateUserCubit>(context).changeAvatar(user, image!);
        setState(() => isProgressAvatarHide = true);
        response.fold(
          (l) => showSnakeBar(context, l.message),
          (url) {
            imagePath = image.path;
            user = user.copyWith(avatar: url);
            setState(() {});
          },
        );
      },
      child: AbsorbPointer(
        child: SizedBox(
          height: 140,
          width: 140,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                    height: 130,
                    width: 130,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColor.blue, width: 2)),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        child: imagePath.isNotEmpty
                            ? Image(image: FileImage(File(imagePath)), fit: BoxFit.cover)
                            : !isUrlValid(user.avatar ?? "")
                                ? const Image(image: AssetImage('images/avatar.png'), fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: user.avatar!,
                                    placeholder: (_, __) => LoadingWidget(size: 50, color: AppColor.blue),
                                    errorWidget: (_, __, ___) => const Text("something error"),
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    )),
              ),
              if (imagePath.isNotEmpty || (user.avatar ?? "").isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 130,
                    width: 130,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Colors.white60, shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.camera_alt, color: Colors.black54, size: 50.0),
                        const SizedBox(height: 10.0),
                        Text("تغییر تصویر", style: defaultTextStyle(context, headline: 5).c(Colors.black54))
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      const Spacer(),
                      Text("اطلاعات شخصی", style: defaultTextStyle(context, headline: 3)),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OurTextField(
                        title: "نام",
                        textFormField: TextFormField(
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: firstNameController,
                          keyboardType: TextInputType.name,
                          onTap: () => setState(() => fixRtlFlutterBug(firstNameController)),
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: "نام",
                            prefixIcon: const Icon(Icons.person_outline, color: Color(0xffA0A8B1), size: 25.0),
                          ),
                          validator: (value) {
                            if (value == null) return null;
                            if (value.isEmpty) return "این فیلد الزامی است";
                            if (value.length < 2) return "نام کوتاه است";
                            return null;
                          },
                          onSaved: (value) => user = user.copyWith(firstName: value),
                        ),
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      OurTextField(
                        title: "نام خانوادگی",
                        textFormField: TextFormField(
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          onTap: () => setState(() => fixRtlFlutterBug(lastNameController)),
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: "نام خانوادگی",
                            prefixIcon: const Icon(Icons.person_outline, color: Color(0xffA0A8B1), size: 25.0),
                          ),
                          validator: (value) {
                            if (value == null) return null;
                            if (value.isEmpty) return "این فیلد الزامی است";
                            if (value.length < 2) return "نام خانوادگی کوتاه است";
                            return null;
                          },
                          onSaved: (value) => user = user.copyWith(lastName: value),
                        ),
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      OurTextField(
                        title: "نام پدر",
                        textFormField: TextFormField(
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: fatherNameController,
                          keyboardType: TextInputType.name,
                          onTap: () => setState(() => fixRtlFlutterBug(fatherNameController)),
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: "نام پدر",
                            prefixIcon: const Icon(Icons.person_outline, color: Color(0xffA0A8B1), size: 25.0),
                          ),
                          validator: (value) {
                            if (value == null) return null;
                            if (value.isEmpty) return "این فیلد الزامی است";
                            if (value.length < 2) return "نام پدر کوتاه است";
                            return null;
                          },
                          onSaved: (value) => user = user.copyWith(fatherName: value),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12.0),
                          Text(
                            "تاریخ تولد",
                            style: defaultTextStyle(context, headline: 5),
                          ),
                          const SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () async {
                              closeKeyboard();
                              Jalali? picked = await showPersianDatePicker(
                                context: context,
                                initialDate: Jalali(Jalali.now().year-20, Jalali.now().month),
                                firstDate: Jalali(1300, 1),
                                lastDate: Jalali(Jalali.now().year-12, 1),
                              );
                              if (picked == null) return;
                              user = user.copyWith(birthDate: picked);
                              setState(() {});
                            },
                            child: AbsorbPointer(
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Color(0xffF2F4F5),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 10.0),
                                    const Icon(Icons.calendar_month, color: Color(0xffA0A8B1), size: 25.0),
                                    const SizedBox(width: 10.0),
                                    user.birthDate == null
                                        ? Text(
                                            "تاریخ تولد",
                                            style: defaultTextStyle(context, headline: 4).c(user.birthDate == null ? Colors.grey : Colors.black),
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                user.birthDate!.day.toString(),
                                                style: defaultTextStyle(context, headline: 4).c(user.birthDate == null ? Colors.grey : Colors.black),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Text(
                                                monthNames[user.birthDate!.month - 1],
                                                style: defaultTextStyle(context, headline: 4).c(user.birthDate == null ? Colors.grey : Colors.black),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Text(
                                                user.birthDate!.year.toString(),
                                                style: defaultTextStyle(context, headline: 4).c(user.birthDate == null ? Colors.grey : Colors.black),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      const SizedBox(height: 8.0),
                      ToggleSwitch(
                        minWidth: 130,
                        minHeight: 55.0,
                        fontSize: 16.0,
                        initialLabelIndex: Gender.values.indexWhere((element) => element == gender),
                        activeBgColor: [Theme.of(context).primaryColor],
                        activeFgColor: Colors.white,
                        inactiveBgColor: const Color(0xffF2F4F5),
                        inactiveFgColor: Colors.grey[0],
                        totalSwitches: Gender.values.length,
                        labels: Gender.values.map((e) => e.persianName).toList(),
                        onToggle: (index) {
                          gender = Gender.values[index!];
                          user = user.copyWith(gender: gender);
                        },
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ],
              ),
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

  void initialTextEditingController() {
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    fatherNameController = TextEditingController(text: user.fatherName);
    phoneController = TextEditingController(text: GetIt.instance<LoginApi>().getUserData().phoneNumber);
    nationalCodeController = TextEditingController(text: GetIt.instance<LoginApi>().getUserData().nationalCode);
    gender = user.gender;
  }
}
