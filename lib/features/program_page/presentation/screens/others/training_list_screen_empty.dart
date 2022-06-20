import 'package:flutter/material.dart';

class TrainingListScreenEmpty extends StatefulWidget {
  const TrainingListScreenEmpty({Key? key}) : super(key: key);

  @override
  State<TrainingListScreenEmpty> createState() => _TrainingScreenLoadingState();
}

class _TrainingScreenLoadingState extends State<TrainingListScreenEmpty> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Empty'),
    );
  }
}
