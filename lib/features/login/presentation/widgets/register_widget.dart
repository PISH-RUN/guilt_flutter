import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/icon_name_widget.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:guilt_flutter/features/login/presentation/manager/register_cubit.dart';
import 'package:guilt_flutter/features/login/presentation/manager/register_state.dart';
import 'package:qlevar_router/qlevar_router.dart';

class RegisterWidget extends StatefulWidget {
  final String phoneNumber;
  final String nationalCode;
  final bool isLocked;
  final void Function() onSuccessful;

  const RegisterWidget({required this.phoneNumber, required this.nationalCode, required this.isLocked, required this.onSuccessful, Key? key})
      : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController phoneController;
  late TextEditingController nationalCodeController;

  @override
  void initState() {
    phoneController = TextEditingController(text: widget.phoneNumber);
    nationalCodeController = TextEditingController(text: widget.nationalCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(success: () => widget.onSuccessful(), orElse: () {});
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const IconNameWidget(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 10.0),
                                Text("لطفا اطلاعات خود را وارد کنید", style: Theme.of(context).textTheme.headline4),
                                const SizedBox(height: 20.0),
                                AbsorbPointer(
                                  absorbing: widget.isLocked,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "شماره تلفن",
                                            helperText: "",
                                            prefixIcon: const Icon(Icons.phone, color: AppColor.blue, size: 22.0),
                                            fillColor: widget.isLocked ? const Color(0xffcbcbcb) : const Color(0xffffffff),
                                          ),
                                          onFieldSubmitted: (value) => onSubmitButton(context),
                                          keyboardType: TextInputType.number,
                                          controller: phoneController,
                                          validator: (value) {
                                            if (value == null) return null;
                                            if (value.isEmpty) return "وارد کردن شماره تلفن ضروری است";
                                            if (!validatePhoneNumber(value)) return "شماره تلفن معتبر نیست";
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: "کد ملی",
                                            helperText: "",
                                            prefixIcon: Icon(Icons.pin, color: AppColor.blue, size: 22.0),
                                          ),
                                          onFieldSubmitted: (value) => onSubmitButton(context),
                                          keyboardType: TextInputType.number,
                                          controller: nationalCodeController,
                                          validator: (value) {
                                            if (value == null) return null;
                                            if (value.isEmpty) return "وارد کردن کد ملی ضروری است";
                                            if (value.length != 10) return "کد ملی نامعتبر نیست";
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14.0),
                                OurButton(
                                  onTap: () => onSubmitButton(context),
                                  isLoading: state is Loading,
                                  title: "تایید",
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  state.maybeWhen(
                                      error: (failure) =>
                                          failure.failureType == FailureType.authentication ? "اطلاعات شما نادرست است" : failure.message,
                                      orElse: () => ""),
                                  textAlign: TextAlign.center,
                                  style: defaultTextStyle(context, headline: 4).c(Colors.red),
                                ),
                                const SizedBox(height: 10.0),
                                if (appMode == AppMode.psp)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () => QR.to('psp/signUp'),
                                      child: Text(
                                        "ثبت نام psp",
                                        textAlign: TextAlign.center,
                                        style: defaultTextStyle(context, headline: 4).c(Colors.red),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onSubmitButton(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    BlocProvider.of<RegisterCubit>(context).registerWithPhoneNumber(phoneController.text, nationalCodeController.text);
  }
}
