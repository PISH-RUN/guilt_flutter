import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/commons/TextFieldConfig.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/commons/widgets/our_item_picker.dart';
import 'package:guilt_flutter/commons/widgets/our_text_field.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:guilt_flutter/commons/widgets/text_form_field_wrapper.dart';
import 'package:guilt_flutter/features/psp/domain/entities/psp_user.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/sign_up_psp_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/sign_up_psp_state.dart';
import 'package:qlevar_router/qlevar_router.dart';

class SignUpPsp extends StatefulWidget {
  const SignUpPsp({Key? key}) : super(key: key);

  @override
  _SignUpPspState createState() => _SignUpPspState();

  static Widget wrappedRoute() {
    return BlocProvider(create: (ctx) => GetIt.instance<SignUpPspCubit>(), child: const SignUpPsp());
  }
}

class _SignUpPspState extends State<SignUpPsp> {
  late PspUser pspUser;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController organController;
  late TextEditingController mobileController;
  late TextEditingController nationalCodeController;
  late TextEditingController provinceController;
  late TextEditingController cityController;

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    pspUser = PspUser.empty();
    firstNameController = TextEditingController(text: '');
    lastNameController = TextEditingController(text: '');
    organController = TextEditingController(text: '');
    mobileController = TextEditingController(text: '');
    nationalCodeController = TextEditingController(text: '');
    provinceController = TextEditingController(text: '');
    cityController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(body: formWidget(context)),
    );
  }

  Form formWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40.0),
            baseInformationWidget(context),
            const SizedBox(height: 10.0),
            submitButton(context),
            KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) => SizedBox(height: isKeyboardVisible ? 265.0 : 20.0)),
          ],
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return BlocConsumer<SignUpPspCubit, SignUpPspState>(
      listener: (context, state) => state.maybeWhen(
        success: () {
          showSnakeBar(context, "?????????? ?????????? ???????? ?????????? ??????????");
          QR.back();
        },
        error: (failure) =>
            showSnakeBar(context, failure.message.contains("incorrect national_code or mobile") ? "?????? ???????? ?????? ?????? ??????????" : failure.message),
        orElse: () {},
      ),
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            if (!formKey.currentState!.validate()) {
              return;
            }
            formKey.currentState!.save();
            BlocProvider.of<SignUpPspCubit>(context).signUpPsp(pspUser);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.all(18),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
            child: state is Loading
                ? LoadingWidget(size: 18, color: Colors.white)
                : Text("?????? ??????", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
          ),
        );
      },
    );
  }

  double paddingBetweenTextFiled = 10.0;

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("?????????????? ????????", style: defaultTextStyle(context, headline: 3)),
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: paddingBetweenTextFiled),
                      OurTextField(
                        title: "??????",
                        textFormField: TextFormField(
                          inputFormatters: TextFieldConfig.inputFormattersFirstName(),
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: firstNameController,
                          keyboardType: TextInputType.name,
                          onTap: () => setState(() => fixRtlFlutterBug(firstNameController)),
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: "??????",
                            prefixIcon: const Icon(Icons.person, color: Color(0xffA0A8B1), size: 25.0),
                          ),
                          validator: (value) => TextFieldConfig.validateFirstName(value, '??????'),
                          onSaved: (value) => pspUser = pspUser.copyWith(firstName: value),
                        ),
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      OurTextField(
                        title: "?????? ????????????????",
                        textFormField: TextFormField(
                          inputFormatters: TextFieldConfig.inputFormattersLastName(),
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          onTap: () => setState(() => fixRtlFlutterBug(lastNameController)),
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: "?????? ????????????????",
                            prefixIcon: const Icon(Icons.person, color: Color(0xffA0A8B1), size: 25.0),
                          ),
                          validator: (value) => TextFieldConfig.validateLastName(value, '?????? ????????????????'),
                          onSaved: (value) => pspUser = pspUser.copyWith(lastName: value),
                        ),
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      OurTextField(
                        title: "?????? ????????????",
                        textFormField: TextFormField(
                          inputFormatters: TextFieldConfig.inputFormattersOrganName(),
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: organController,
                          keyboardType: TextInputType.name,
                          onTap: () => setState(() => fixRtlFlutterBug(organController)),
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: '?????? ????????????',
                            prefixIcon: const Icon(Icons.store, color: Color(0xffA0A8B1), size: 25.0),
                          ),
                          validator: (value) => TextFieldConfig.validateOrganName(value),
                          onSaved: (value) => pspUser = pspUser.copyWith(organ: value),
                        ),
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      OurTextField(
                        title: "?????????? ????????????",
                        textFormField: TextFormField(
                          inputFormatters: TextFieldConfig.inputFormattersEmpty(),
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.end,
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: '?????????? ????????????',
                            contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                            prefixIcon: const Icon(Icons.phone, color: Color(0xffA0A8B1), size: 25.0),
                            hintTextDirection: TextDirection.ltr,
                          ),
                          validator: (value) => TextFieldConfig.validatePhoneNumber(value),
                          onSaved: (value) => pspUser = pspUser.copyWith(mobile: value),
                        ),
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      OurTextField(
                        title: "???? ??????",
                        textFormField: TextFormField(
                          inputFormatters: TextFieldConfig.inputFormattersNationalCode(),
                          style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                          controller: nationalCodeController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.end,
                          decoration: defaultInputDecoration(context).copyWith(
                            hintText: "???? ??????",
                            contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                            prefixIcon: const Icon(Icons.pin, color: Color(0xffA0A8B1), size: 25.0),
                            hintTextDirection: TextDirection.ltr,
                          ),
                          validator: (value) => TextFieldConfig.validateNationalCode(value),
                          onSaved: (value) => pspUser = pspUser.copyWith(nationalCode: value),
                        ),
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      OurItemPicker(
                        hint: "??????????",
                        icon: Icons.pin_drop_outlined,
                        items: null,
                        onFillParams: () => getIranProvince(context),
                        onChanged: (value) => pspUser = pspUser.copyWith(province: value),
                        currentText: provinceController.text,
                        controller: provinceController,
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      const SizedBox(height: 26.0),
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
