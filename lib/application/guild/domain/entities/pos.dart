import 'package:equatable/equatable.dart';

class Pos extends Equatable {
  final int terminalId;
  final int accountNumber;

  const Pos({
    required this.terminalId,
    required this.accountNumber,
  });

  @override
  List<Object> get props => [terminalId];
}