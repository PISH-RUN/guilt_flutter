import 'package:equatable/equatable.dart';

class FaqQuestion extends Equatable {
  final String question;
  final String answer;

  const FaqQuestion({
    required this.question,
    required this.answer,
  });

  @override
  List<Object> get props => [question];
}
