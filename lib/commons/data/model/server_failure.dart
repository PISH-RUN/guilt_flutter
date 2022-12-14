import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/parse_error_message.dart';
import 'package:http/http.dart';
import '../../failures.dart';

const int AUTHENTICATION_IS_WRONG_STATUS_CODE = 401;
const int FORBIDDEN_STATUS_CODE = 403;

class ServerFailure extends Failure {
  final int statusCode;

  ServerFailure(Response response)
      : statusCode = response.statusCode,
        super(parseErrorMessage(response.body), failureType: FailureType.serverError);

  factory ServerFailure.fromServer(Response response) {
    if (response.statusCode == 504) return ServerFailure.badVpn();
    if (response.statusCode >= 500) return ServerFailure.somethingWentWrong();
    if (response.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE) return ServerFailure.notLoggedInYet();
    if (response.statusCode == FORBIDDEN_STATUS_CODE) return ServerFailure.notPermission();
    return ServerFailure(response);
  }

  ServerFailure.noInternet()
      : statusCode = -1,
        super("شما به اینترنت متصل نیستید", failureType: FailureType.noInternet);

  ServerFailure.badVpn()
      : statusCode = -1,
        super("دسترسی به اینترنت ندارید در صورت روشن بودن فیلتر شکن آن را خاموش کنید", failureType: FailureType.noInternet);

  ServerFailure.crash()
      : statusCode = -1,
        super("از اتصال دستگاه به اینترنت مطمئن شوید", failureType: FailureType.somethingWentWrong);

  ServerFailure.notPermission()
      : statusCode = -71,
        super(appMode.forbiddenError, failureType: FailureType.somethingWentWrong);

  ServerFailure.notLoggedInYet()
      : statusCode = AUTHENTICATION_IS_WRONG_STATUS_CODE,
        super("لطفا ابتدا وارد شوید", failureType: FailureType.authentication);

  ServerFailure.somethingWentWrong()
      : statusCode = -2,
        super("بروز مشکل ناشناخته در سرور", failureType: FailureType.somethingWentWrong);

  ServerFailure.wrongOtp()
      : statusCode = -2,
        super("کد ورود به سامانه اصناف صحیح نمی باشد", failureType: FailureType.other);
}
