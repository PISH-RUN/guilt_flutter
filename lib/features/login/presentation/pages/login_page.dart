import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/app_route.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/icon_name_widget.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:guilt_flutter/features/login/presentation/manager/login_cubit.dart';
import 'package:guilt_flutter/features/login/presentation/manager/login_state.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static Widget wrappedRoute() {
    return BlocProvider(create: (ctx) => GetIt.instance<LoginCubit>(), child: LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SmsUserConsent smsUserConsent;
  final TextEditingController verifyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    smsUserConsent = SmsUserConsent(
        phoneNumberListener: () => setState(() {}),
        smsListener: () {
          verifyController.text = extractNumberInLargeText(smsUserConsent.receivedSms ?? "", ONE_TIME_PASSWORD_LENGTH);
          if (verifyController.text
              .trim()
              .length == 4) {
            onSubmitButton();
          }
          smsUserConsent.dispose();
        });
    smsUserConsent.requestSms();
  }

  @override
  void dispose() {
    smsUserConsent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          state.maybeWhen(success: () => QR.navigator.replaceAll(redirectPath), orElse: () {});
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
                      child: Form(
                        key: formKey,
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 25.0),
                                Text("لطفا کد تایید را وارد کنید", style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4),
                                const SizedBox(height: 30.0),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: TextFormField(
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
                                const SizedBox(height: 30.0),
                                OurButton(
                                  onTap: () => onSubmitButton(),
                                  isLoading: state is Loading,
                                  title: "تایید",
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  state.maybeWhen(error: (failure) => failure.message, orElse: () => ""),
                                  textAlign: TextAlign.center,
                                  style: defaultTextStyle(context, headline: 4).c(Colors.red),
                                ),
                                const SizedBox(height: 20.0),
                                GestureDetector(
                                  onTap: () => QR.back(),
                                  child: Text("ارسال مجدد کد تایید",
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(color: Colors.black.withOpacity(0.45))),
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

  void onSubmitButton() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    BlocProvider.of<LoginCubit>(context).loginWithOneTimePassword(verifyController.text);
  }
}
