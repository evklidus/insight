import 'package:flutter/material.dart';

class StandartLoading extends StatelessWidget {
  const StandartLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
