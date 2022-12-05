import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';

class PosModel extends Pos {
  const PosModel({
    required String accountNumber,
    required String terminalId,
    required String psp,
    required String shebaCode,
  }) : super(
          accountNumber: accountNumber,
          terminalId: terminalId,
          psp: psp,
          shebaCode: shebaCode,
        );

  factory PosModel.fromJson(Map<String, dynamic> json) {
    return PosModel(
      accountNumber: JsonParser.stringParser(json, ['AccountNumber']),
      terminalId: JsonParser.stringParser(json, ['TerminalId']),
      psp: JsonParser.stringParser(json, ['PSP']),
      shebaCode: JsonParser.stringParser(json, ['sheba']),
    );
  }

  factory PosModel.fromSuper(Pos pos) => PosModel(
        accountNumber: pos.accountNumber,
        terminalId: pos.terminalId,
        psp: pos.psp,
        shebaCode: pos.shebaCode,
      );

  Map<String, dynamic> toJson() => {
        'AccountNumber': accountNumber,
        'TerminalId': terminalId,
        'PSP': psp,
        'sheba': shebaCode,
      };
}
