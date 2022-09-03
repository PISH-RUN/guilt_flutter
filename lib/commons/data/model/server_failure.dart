import 'package:guilt_flutter/application/parse_error_message.dart';
import 'package:http/http.dart';
import '../../failures.dart';

const int AUTHENTICATION_IS_WRONG_STATUS_CODE = 401;
const int FORBIDDEN_STATUS_CODE = 403;

class ServerFailure extends Failure {
  final int statusCode;

  ServerFailure(Response response)
      : statusCode = response.statusCode,
        super(parseErrorMessage(response.body), failureType: FailureType.serverError); //todo parse error here

  ServerFailure.fromMessage(String message)
      : statusCode = -1,
        super(message, failureType: FailureType.serverError);

  ServerFailure.noInternet()
      : statusCode = -1,
        super("شما به اینترنت متصل نیستید", failureType: FailureType.noInternet);

  ServerFailure.notPermission()
      : statusCode = -71,
        super("شما دسترسی به این محتوا ندارید", failureType: FailureType.somethingWentWrong);

  ServerFailure.notLoggedInYet()
      : statusCode = AUTHENTICATION_IS_WRONG_STATUS_CODE,
        super("لطفا ابتدا وارد شوید", failureType: FailureType.authentication);

  ServerFailure.notBuyAccountYet()
      : statusCode = AUTHENTICATION_IS_WRONG_STATUS_CODE,
        super("لطفا ابتدا اشتراک تهیه کنید", failureType: FailureType.payment);

  ServerFailure.somethingWentWrong()
      : statusCode = -2,
        super("بروز مشکل ناشناخته در سرور", failureType: FailureType.somethingWentWrong);
}
