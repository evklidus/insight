import 'package:flutter/material.dart';

class TrainingListScreenLoading extends StatefulWidget {
  const TrainingListScreenLoading({Key? key}) : super(key: key);

  @override
  State<TrainingListScreenLoading> createState() => _TrainingScreenLoadingState();
}

class _TrainingScreenLoadingState extends State<TrainingListScreenLoading> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
