import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/data/model/offline_first_data.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class OfflineFirstTopBarWidget extends StatelessWidget {
  final TopLoadingBarState topLoadingBarState;

  const OfflineFirstTopBarWidget({required this.topLoadingBarState, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late OfflineFirstData state;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: OfflineFirstTopBarWidget(topLoadingBarState: state.topLoadingBarState),
        ),
        switch(state.dataMode)
        {

        }
        state.when(
          loading: () => LoadingWidget(),
          error: (failure) => Center(child: Text(failure.message)),
          empty: () => const Center(child: Text("خالی است")),
          loaded: (data) {
            return ;
          },
        ),
      ],
    );



    switch (topLoadingBarState) {
      case TopLoadingBarState.normal:
        return const SizedBox();
      case TopLoadingBarState.loading:
        return LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor));
      case TopLoadingBarState.noNet:
        return Container(
          width: double.infinity,
          height: 30,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.rectangle),
          child: Text('شما به اینترنت متصل نیستید', style: defaultTextStyle(context)),
        );
    }
  }
}
