import 'package:flutter/material.dart';

class ProgramsScreenLoading extends StatelessWidget {
  const ProgramsScreenLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
