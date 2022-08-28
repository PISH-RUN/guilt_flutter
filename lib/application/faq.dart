import 'package:dartz/dartz.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/check_something_before_open_app.dart';
import 'package:guilt_flutter/application/faq_question.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';

class Faq extends StatelessWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<ServerFailure, List<FaqQuestion>>>(
        future: getListOfFaqQuestions(),
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
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  boxShadow: simpleShadow(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: ExpandablePanel(
                    key: UniqueKey(),
                    header: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 0.0, right: 12.0, left: 12.0),
                        child: Text(
                          questionList[index].question,
                          textAlign: TextAlign.start,
                          style: defaultTextStyle(context, headline: 4),
                        ),
                      ),
                    ),
                    collapsed: const SizedBox(),
                    expanded: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0, right: 12.0, left: 42.0),
                        child: Text(
                          questionList[index].answer,
                          textAlign: TextAlign.justify,
                          style: defaultTextStyle(context, headline: 5).c(Colors.black54),
                        ),
                      ),
                    ),
                    theme: const ExpandableThemeData(
                      tapBodyToExpand: false,
                      tapBodyToCollapse: true,
                      tapHeaderToExpand: true,
                      hasIcon: true,
                      useInkWell: false,
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
