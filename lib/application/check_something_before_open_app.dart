import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/faq_question.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';

List<FaqQuestion> faqQuestionList = [];

Future<Either<ServerFailure, List<FaqQuestion>>> checkSomethingBeforeOpenApp() async {
  return GetIt.instance<RemoteDataSource>().getFromServer(
    url: '',
    params: {},
    mapSuccess: (data) => faqQuestionList =
        (data as List).map((data) => FaqQuestion(question: JsonParser.stringParser(data, ['question']), answer: JsonParser.stringParser(data, ['answer']))).toList(),
  );
}
