import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/commons/widgets/warning_dialog.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:guilt_flutter/features/profile/domain/entities/gender_type.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/get_user_cubit.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/get_user_state.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/update_user_cubit.dart';
import 'package:guilt_flutter/features/profile/presentation/manager/update_user_state.dart';
import 'package:guilt_flutter/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
            if (failure.failureType == FailureType.haveNoGuild) {
              user = UserInfo.empty();
              return FormWidget(user: user, isEditable: true);
            }
            return Center(child: Text(failure.message));
          },
          loaded: (userInfo) {
            user = userInfo;
            return FormWidget(user: user, isEditable: false);
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
  late TextEditingController phoneController;
  late TextEditingController nationalCodeController;
  late Gender gender;
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isEditable = false;
  late UserInfo user;

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
                        setState(() {});
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
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    nationalCodeController = TextEditingController(text: widget.user.nationalCode);
    gender = widget.user.gender;
  }

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
                  const SizedBox(height: 6.0),
                  QR.currentPath.contains('signIn/profile') || isEditable ? const SizedBox(height: 15.0) : avatarWidget(context),
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
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        await BlocProvider.of<UpdateUserCubit>(context).changeAvatar(user, image!);
        BlocProvider.of<GetUserCubit>(context).initialPage();
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
                  child: !isUrlValid(user.avatar ?? "")
                      ? const Image(image: AssetImage('images/avatar.png'))
                      : ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                          child: Image(image: NetworkImage(user.avatar!), fit: BoxFit.cover),
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
                                onSaved: (value) => user = user.copyWith(firstName: value),
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
                                onSaved: (value) => user = user.copyWith(lastName: value),
                              )
                            : labelWidget(Icons.person_outline, "نام خانوادگی", lastNameController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                decoration: defaultInputDecoration().copyWith(
                                  labelText: "شماره تلفن",
                                  prefixIcon: const Icon(Icons.phone),
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
                                onSaved: (value) => user = user.copyWith(phoneNumber: value),
                              )
                            : labelWidget(Icons.phone, "شماره تلفن", phoneController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable ? const SizedBox() : labelWidget(Icons.pin, "کد ملی", nationalCodeController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? ToggleSwitch(
                                minWidth: 120,
                                minHeight: 55.0,
                                fontSize: 16.0,
                                initialLabelIndex: Gender.values.indexWhere((element) => element == gender),
                                activeBgColor: [Theme.of(context).primaryColor],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey[300],
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
