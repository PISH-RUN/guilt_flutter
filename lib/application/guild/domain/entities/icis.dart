import 'package:equatable/equatable.dart';

class Isic extends Equatable {
  final String name;
  final String code;

  const Isic({
    required this.name,
    required this.code,
  });

  @override
  List<Object> get props => [code];
}
