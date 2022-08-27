import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/faq_question.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';

class Faq extends StatelessWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<ServerFailure, List<FaqQuestion>>>(
        future: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          }
          if (snapshot.data!.isLeft()) {
            return Center(
              child: Text(
                snapshot.data!.swap().getOrElse(() => throw UnimplementedError()).message,
                textAlign: TextAlign.center,
                style: defaultTextStyle(context, headline: 4),
              ),
            );
          }
          final questionList = snapshot.data!.getOrElse(() => throw UnimplementedError());
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: questionList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    questionList[index].question,
                    textAlign: TextAlign.center,
                    style: defaultTextStyle(context, headline: 4),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    questionList[index].answer,
                    textAlign: TextAlign.center,
                    style: defaultTextStyle(context, headline: 5).c(Colors.black54),
                  ),
                  const SizedBox(height: 20.0),
                ],
              );
            },
          );
        });
  }
}
