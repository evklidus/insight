import 'package:flutter/material.dart';

class ProgramPageScreenLoading extends StatelessWidget {
  const ProgramPageScreenLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
