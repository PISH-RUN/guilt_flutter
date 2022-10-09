import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/icon_name_widget.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_data.dart';
import 'package:guilt_flutter/features/login/presentation/manager/login_cubit.dart';
import 'package:guilt_flutter/features/login/presentation/manager/login_state.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

class LoginWidget extends StatefulWidget {
  final void Function(UserData userData) onSuccess;
  final bool isIconLogoVisible;

  const LoginWidget({required this.onSuccess, this.isIconLogoVisible = true, Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late SmsUserConsent smsUserConsent;
  final TextEditingController verifyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  int expireAt = 180;

  @override
  void initState() {
    super.initState();
    startTimer();
    smsUserConsent = SmsUserConsent(
        phoneNumberListener: () => setState(() {}),
        smsListener: () {
          verifyController.text = extractNumberInLargeText(smsUserConsent.receivedSms ?? "", ONE_TIME_PASSWORD_LENGTH);
          if (verifyController.text.trim().length == ONE_TIME_PASSWORD_LENGTH) {
            onSubmitButton();
          }
          smsUserConsent.dispose();
        });
    smsUserConsent.requestSms();
  }

  @override
  void dispose() {
    smsUserConsent.dispose();
    expireAt = 0;
    super.dispose();
  }

  startTimer() async {
    expireAt = 120;
    while (expireAt > 0) {
      setState(() => expireAt--);
      await Future.delayed(const Duration(seconds: 1), () => "1");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          state.maybeWhen(success: (userData) => widget.onSuccess(userData), orElse: () {});
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isIconLogoVisible) const IconNameWidget(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Form(
                        key: formKey,
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 10.0),
                                Text("لطفا کد تایید را وارد کنید", style: Theme.of(context).textTheme.headline4),
                                const SizedBox(height: 16.0),
                                Text(LoginCubit.phoneNumber, style: Theme.of(context).textTheme.headline4),
                                const SizedBox(height: 4.0),
                                GestureDetector(
                                  onTap: () => QR.back(),
                                  child: Text("تغییر شماره تلفن",
                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black.withOpacity(0.45))),
                                ),
                                const SizedBox(height: 26.0),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 2, color: AppColor.blue),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 1.2, color: Color(0xd9848484)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 1.5, color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 2, color: Colors.red),
                                      ),
                                      labelText: "کد تایید",
                                      helperText: "",
                                      prefixIcon: Icon(Icons.lock, color: AppColor.blue, size: 22.0),
                                    ),
                                    onFieldSubmitted: (value) => onSubmitButton(),
                                    keyboardType: TextInputType.number,
                                    controller: verifyController,
                                    validator: (value) {
                                      if (value == null) return null;
                                      if (value.isEmpty) return "وارد کردن کد تایید ضروری است";
                                      if (value.length != ONE_TIME_PASSWORD_LENGTH) return "کد تایید معتبر نمی باشد";
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  state.maybeWhen(
                                    error: (failure) => failure.failureType == FailureType.authentication ? "کد تایید نادرست است" : failure.message,
                                    orElse: () => "",
                                  ),
                                  textAlign: TextAlign.center,
                                  style: defaultTextStyle(context, headline: 4).c(Colors.red),
                                ),
                                const SizedBox(height: 8.0),
                                OurButton(
                                  onTap: () {
                                    if (expireAt > 0) {
                                      onSubmitButton();
                                    } else {
                                      BlocProvider.of<LoginCubit>(context).resendVerifyCode();
                                      startTimer();
                                    }
                                  },
                                  isLoading: state is Loading,
                                  color: expireAt > 0 ? null : Colors.green,
                                  title: expireAt > 0 ? "تایید" : "ارسال مجدد کد تایید",
                                ),
                                const SizedBox(height: 16.0),
                                expireAt > 0
                                    ? Text(
                                        "ارسال مجدد کد تا ${(expireAt ~/ 60).toString().padLeft(2, '0')}:${(expireAt % 60).toString().padLeft(2, '0')}",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black.withOpacity(0.45)),
                                      )
                                    : const SizedBox(height: 8.0),
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

  void onSubmitButton() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    BlocProvider.of<LoginCubit>(context).loginWithOneTimePassword(verifyController.text);
  }
}
