import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/widgets/our_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../application/colors.dart';
import '../../../../commons/failures.dart';
import '../../../../commons/fix_rtl_flutter_bug.dart';
import '../../../../commons/text_style.dart';
import '../../../../commons/utils.dart';
import '../../../../commons/widgets/loading_widget.dart';
import '../../../../commons/widgets/simple_snake_bar.dart';
import '../../../../commons/widgets/warning_dialog.dart';
import '../../../../main.dart';
import '../../../login/api/login_api.dart';
import '../../domain/entities/gender_type.dart';
import '../../domain/entities/user_info.dart';
import '../manager/get_user_cubit.dart';
import '../manager/get_user_state.dart';
import '../manager/update_user_cubit.dart';
import '../manager/update_user_state.dart';

final List<String> monthNames = [
  "فروردین",
  "اردیبهشت",
  "خرداد",
  "تیر",
  "مرداد",
  "شهریور",
  "مهر",
  "آبان",
  "آذر",
  "دی",
  "بهمن",
  "اسفند",
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

  static Widget wrappedRoute() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdateUserCubit>(create: (BuildContext context) => GetIt.instance<UpdateUserCubit>()),
        BlocProvider<GetUserCubit>(create: (BuildContext context) => GetIt.instance<GetUserCubit>()),
      ],
      child: const ProfilePage(),
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late UserInfo user;

  @override
  void initState() {
    BlocProvider.of<GetUserCubit>(context).initialPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GetUserCubit, GetUserState>(
      builder: (context, state) {
        return state.when(
          loading: () => LoadingWidget(),
          error: (failure) {
            if (failure.failureType == FailureType.haveNoGuildAndProfile) {
              user = UserInfo.empty();
              return FormWidget(user: user, isEditable: true);
            }
            return Center(child: Text(failure.message));
          },
          loaded: (userInfo) {
            user = userInfo;
            return FormWidget(user: user, isEditable: QR.currentPath.contains('signIn/profile'));
          },
        );
      },
    ));
  }
}

class FormWidget extends StatefulWidget {
  final UserInfo user;
  final bool isEditable;

  const FormWidget({required this.user, required this.isEditable, Key? key}) : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController fatherNameController;
  late TextEditingController phoneController;
  late TextEditingController nationalCodeController;
  late Gender gender;
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isEditable = false;
  late UserInfo user;

  String imagePath = '';

  @override
  void initState() {
    user = widget.user;
    initialTextEditingController();
    isEditable = widget.isEditable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateUserCubit, UpdateUserState>(
      listener: (context, state) {
        // imagePath = '';
        state.maybeWhen(
          error: (failure) => showSnakeBar(context, failure.message),
          success: () {
            if (QR.currentPath.contains('signIn/profile')) {
              QR.navigator.replaceAll(initPath);
            }
          },
          orElse: () {},
        );
      },
      builder: (context, _) {
        return Scaffold(
          body: formWidget(context),
          floatingActionButton: BlocBuilder<GetUserCubit, GetUserState>(
            builder: (context, state) {
              return isEditable
                  ? FloatingActionButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        formKey.currentState!.save();
                        BlocProvider.of<UpdateUserCubit>(context).updateUserInfo(user);
                        isEditable = false;
                        // imagePath = '';
                        if (QR.currentPath.contains('signIn/profile')) {
                          QR.navigator.replaceAll(appMode.initPath);
                        } else {
                          setState(() {});
                        }
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.save),
                    )
                  : const SizedBox();
            },
          ),
        );
      },
    );
  }

  void initialTextEditingController() {
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    fatherNameController = TextEditingController(text: widget.user.fatherName);
    phoneController = TextEditingController(text: GetIt.instance<LoginApi>().getUserData().phoneNumber);
    nationalCodeController = TextEditingController(text: GetIt.instance<LoginApi>().getUserData().nationalCode);
    gender = widget.user.gender;
  }

  bool isProgressAvatarHide = true;

  Form formWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: isProgressAvatarHide ? 0.0 : 1.0,
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      minHeight: 4.0,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  avatarWidget(context),
                  const SizedBox(height: 6.0),
                  baseInformationWidget(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget avatarWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!isEditable) return;
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
              if (isEditable && (imagePath.isNotEmpty || (user.avatar ?? "").isNotEmpty))
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 130,
                    width: 130,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white60,
                      shape: BoxShape.circle,
                    ),
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

  double paddingBetweenTextFiled = 15.0;

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
                      const SizedBox(width: 56.0),
                      const Spacer(),
                      Text("اطلاعات شخصی", style: defaultTextStyle(context, headline: 3)),
                      const Spacer(),
                      isEditable
                          ? const SizedBox(width: 56.0)
                          : GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) => WarningDialog(onResult: (isAccess) {
                                    if (isAccess) {
                                      setState(() => isEditable = true);
                                    }
                                  }),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(Icons.edit, color: Colors.blueGrey, size: 15.0),
                                  const SizedBox(width: 4.0),
                                  Text("ویرایش", style: defaultTextStyle(context, headline: 5).c(Colors.blueGrey)),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  AbsorbPointer(
                    absorbing: !isEditable,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        isEditable
                            ? OurTextField(
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
                              )
                            : labelWidget(Icons.person_outline, "نام", firstNameController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? OurTextField(
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
                              )
                            : labelWidget(Icons.person_outline, "نام خانوادگی", lastNameController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? OurTextField(
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
                              )
                            : labelWidget(Icons.person_outline, "نام پدر", fatherNameController.text),
                        isEditable
                            ? Column(
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
                                      Jalali? picked = await showPersianDatePicker(
                                        context: context,
                                        initialDate: Jalali.now(),
                                        firstDate: Jalali(1385, 8),
                                        lastDate: Jalali(1450, 9),
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
                                                    style:
                                                        defaultTextStyle(context, headline: 4).c(user.birthDate == null ? Colors.grey : Colors.black),
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        user.birthDate!.day.toString(),
                                                        style: defaultTextStyle(context, headline: 4)
                                                            .c(user.birthDate == null ? Colors.grey : Colors.black),
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        monthNames[user.birthDate!.month - 1],
                                                        style: defaultTextStyle(context, headline: 4)
                                                            .c(user.birthDate == null ? Colors.grey : Colors.black),
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        user.birthDate!.year.toString(),
                                                        style: defaultTextStyle(context, headline: 4)
                                                            .c(user.birthDate == null ? Colors.grey : Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : labelWidgetRow(Icons.calendar_month, "تاریخ تولد",
                                [user.birthDate!.day.toString(), monthNames[user.birthDate!.month - 1], user.birthDate!.year.toString()]),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable ? const SizedBox() : labelWidget(Icons.pin, "کد ملی", nationalCodeController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable ? const SizedBox() : labelWidget(Icons.pin, "شماره تلفن", phoneController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? ToggleSwitch(
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
                              )
                            : labelWidget(Icons.male, "جنسیت", user.gender.persianName),
                        SizedBox(height: paddingBetweenTextFiled),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isEditable)
            GestureDetector(
              onTap: () async {
                await GetIt.instance<LoginApi>().signOut();
                QR.navigator.replaceAll(initPath);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(1, 1),
                    )
                  ],
                ),
                child: Text(
                  "خروج از حساب کاربری",
                  style: defaultTextStyle(context, headline: 4).c(Colors.white),
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
