import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/faq_question.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';

List<FaqQuestion> faqQuestionList = [];

Future<Either<ServerFailure, List<FaqQuestion>>> getListOfFaqQuestions() async {
  return const Right(
    [
      FaqQuestion(question: 'با یک کد ملی حق ثبت چند کسب و کار وجود دارد ؟', answer: 'با یک کد ملی خاص کاربر می تواند تا هر تعداد صنف را در سایت ثبت کرده و محدودیتی در این زمینه وجود ندارد .'),
      FaqQuestion(question: 'در صورت مغایرت اطلاعات چه باید کرد؟', answer: 'شما باید در صورت مغایرت اطلاعات خود و یا کسب و کار مورد نظرتان آن را ویرایش نموده و منتظر تایید نهایی آن باشید.'),
      FaqQuestion(question: 'زمان تایید تغییرات چقدر است؟', answer: 'به علت وجود تعداد زیاد اصناف و درخواست ها ممکن است تایید نهایی تغییرات تا چند روز کاری زمان بخواهد. '),
      FaqQuestion(question: 'آیا امکان تغییر کد ملی وجود دارد؟', answer: 'خیر، در این سامانه امکان تغییر کد ملی وجود ندارد و شما باید به سامانه اصلی اصناف کشور مراجعه نمایید و درخواست خود را ثبت نمایید.'),
    ]
  );
}
