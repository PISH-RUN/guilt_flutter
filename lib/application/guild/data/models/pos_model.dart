import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';

class PosModel extends Pos {
  const PosModel({
    required int accountNumber,
    required int terminalId,
  }) : super(
          accountNumber: accountNumber,
          terminalId: terminalId,
        );

  factory PosModel.fromJson(Map<String, dynamic> json) {
    return PosModel(
      accountNumber: JsonParser.intParser(json, ['AccountNumber']),
      terminalId: JsonParser.intParser(json, ['TerminalId']),
    );
  }

  factory PosModel.fromSuper(Pos pos) => PosModel(accountNumber: pos.accountNumber, terminalId: pos.terminalId);

  Map<String, dynamic> toJson() => {'AccountNumber': accountNumber, 'TerminalId': terminalId};
}
