import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/add_pose_widget.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/pos_item.dart';

class PosesListWidget extends StatefulWidget {
  final List<Pos> posesList;
  final void Function(Pos pos) addedNewPose;
  final void Function(Pos pos) deletedOnePose;

  const PosesListWidget({required this.posesList, required this.addedNewPose, required this.deletedOnePose, Key? key}) : super(key: key);

  @override
  State<PosesListWidget> createState() => _PosesListWidgetState();
}

class _PosesListWidgetState extends State<PosesListWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...widget.posesList
                  .map((pos) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: PosItem(pos: pos, onDeletePressed: () => widget.deletedOnePose(pos)),
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AddPoseWidget(addedPose: (pos) => widget.addedNewPose(pos)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
