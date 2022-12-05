import 'package:equatable/equatable.dart';

class Pos extends Equatable {
  final String terminalId;
  final String accountNumber;
  final String shebaCode;
  final String psp;

  const Pos({
    required this.terminalId,
    required this.accountNumber,
    required this.shebaCode,
    required this.psp,
  });

  @override
  List<Object> get props => [terminalId];
}