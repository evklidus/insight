import 'package:flutter/material.dart';

class TrainingListScreenFailure extends StatefulWidget {
  const TrainingListScreenFailure({Key? key}) : super(key: key);

  @override
  State<TrainingListScreenFailure> createState() => _TrainingScreenLoadingState();
}

class _TrainingScreenLoadingState extends State<TrainingListScreenFailure> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error'),
    );
  }
}
