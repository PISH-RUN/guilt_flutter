import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/update_user_cubit.dart';
import 'package:guilt_flutter/main.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController nationalCodeController;

  final GlobalKey<FormState> formKey = GlobalKey();

  bool isEditable = false;

  UserInfo user = const UserInfo(id: 1, firstName: 'محمد', lastName: 'مقصودی', phoneNumber: "0938498324", nationalCode: "8974983248");

  @override
  void initState() {
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    phoneController = TextEditingController(text: user.phoneNumber);
    nationalCodeController = TextEditingController(text: user.nationalCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40.0),
                        baseInformationWidget(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isEditable
          ? FloatingActionButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                formKey.currentState!.save();
                BlocProvider.of<UpdateUserCubit>(context).updateUserInfo(user);
              },
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.save),
            )
          : null,
    );
  }

  Widget avatarWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: AbsorbPointer(
        child: SizedBox(
          height: 140,
          width: 140,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: Image(image: AssetImage('images/avatar.png')),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.black, size: 25.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double paddingBetweenTextFiled = 0.0;

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                              onTap: () => setState(() => isEditable = true),
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
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                controller: firstNameController,
                                keyboardType: TextInputType.name,
                                onTap: () => setState(() => fixRtlFlutterBug(firstNameController)),
                                decoration: defaultInputDecoration().copyWith(labelText: "نام", prefixIcon: const Icon(Icons.person_outline)),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "این فیلد الزامی است";
                                  if (value.length < 2) return "نام کوتاه است";
                                  return null;
                                },
                              )
                            : labelWidget(Icons.person_outline, "نام", firstNameController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                controller: lastNameController,
                                keyboardType: TextInputType.name,
                                onTap: () => setState(() => fixRtlFlutterBug(lastNameController)),
                                decoration:
                                    defaultInputDecoration().copyWith(labelText: "نام خانوادگی", prefixIcon: const Icon(Icons.person_outline)),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "این فیلد الزامی است";
                                  if (value.length < 2) return "نام خانوادگی کوتاه است";
                                  return null;
                                },
                              )
                            : labelWidget(Icons.person_outline, "نام خانوادگی", lastNameController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                decoration: defaultInputDecoration().copyWith(
                                  labelText: "شماره تلفن",
                                  suffixIcon: const Icon(Icons.phone),
                                ),
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "وارد کردن شماره تلفن ضروری است";
                                  if (!validatePhoneNumber(value)) return "شماره تلفن معتبر نیست";
                                  return null;
                                },
                              )
                            : labelWidget(Icons.phone, "شماره تلفن", phoneController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                decoration: defaultInputDecoration().copyWith(
                                  labelText: "کد ملی",
                                  suffixIcon: const Icon(Icons.map),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                controller: nationalCodeController,
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "وارد کردن کد ملی ضروری است";
                                  if (value.length != 10) return "کد ملی باید ده رقم باشد";
                                  return null;
                                },
                              )
                            : labelWidget(Icons.map, "کد ملی", nationalCodeController.text),
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
              onTap: () {
                GetIt.instance<LoginApi>().signOut();
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

  InputDecoration defaultInputDecoration() {
    return const InputDecoration().copyWith(
      helperText: '',
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1.2, color: isEditable ? const Color(0xd9848484) : Colors.transparent),
      ),
    );
  }

  Widget labelWidget(IconData icon, String label, String value) {
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
          const SizedBox(height: 0.0),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              value.isEmpty ? "هنوز وارد نکردید" : value,
              style: defaultTextStyle(context, headline: 3).c(value.isNotEmpty ? Colors.black : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
