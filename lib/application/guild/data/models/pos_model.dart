import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:logger/logger.dart';

class PosModel extends Pos {
  const PosModel({
    required String accountNumber,
    required String terminalId,
    required String psp,
  }) : super(
          accountNumber: accountNumber,
          terminalId: terminalId,
          psp: psp,
        );

  factory PosModel.fromJson(Map<String, dynamic> json) {
    Logger().i("info=> ${json} ");
    return PosModel(
      accountNumber: JsonParser.stringParser(json, ['AccountNumber']),
      terminalId: JsonParser.stringParser(json, ['TerminalId']),
      psp: JsonParser.stringParser(json, ['PSP']),
    );
  }

  factory PosModel.fromSuper(Pos pos) => PosModel(accountNumber: pos.accountNumber, terminalId: pos.terminalId, psp: pos.psp);

  Map<String, dynamic> toJson() => {'AccountNumber': accountNumber, 'TerminalId': terminalId, 'PSP': psp};
}
