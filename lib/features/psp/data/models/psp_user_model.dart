import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/features/psp/domain/entities/psp_user.dart';

class PspUserModel extends PspUser {
  const PspUserModel({
    required int id,
    required String firstName,
    required String lastName,
    required String organ,
    required String province,
    required String mobile,
    required String nationalCode,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          organ: organ,
          province: province,
          mobile: mobile,
          nationalCode: nationalCode,
        );

  factory PspUserModel.fromJson(Map<String, dynamic> json) {
    return PspUserModel(
      id: JsonParser.intParser(json, ['id']),
      firstName: JsonParser.stringParser(json, ['first_name']),
      lastName: JsonParser.stringParser(json, ['last_name']),
      organ: JsonParser.stringParser(json, ['organ']),
      province: JsonParser.stringParser(json, ['province']),
      mobile: JsonParser.stringParser(json, ['mobile']),
      nationalCode: JsonParser.stringParser(json, ['national_code']),
    );
  }

  factory PspUserModel.fromSuper(PspUser pspUser) {
    return PspUserModel(
      id: pspUser.id,
      firstName: pspUser.firstName,
      lastName: pspUser.lastName,
      organ: pspUser.organ,
      province: pspUser.province,
      mobile: pspUser.mobile,
      nationalCode: pspUser.nationalCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'organ': organ,
      'province': province,
      'mobile': mobile,
      'national_code': nationalCode,
    };
  }
}
