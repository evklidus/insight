import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class InternetWarningScreen extends StatelessWidget {
  const InternetWarningScreen({Key? key, required this.onResult}) : super(key: key);

  final Function(bool result) onResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Нет интернет соединения'),
            IconButton(
              onPressed: () async {
                final result = await InternetAddress.lookup('example.com');
                if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
                  onResult(true);
                }
              },
              icon: const Icon(Icons.replay_circle_filled_rounded),
            ),
            TextButton(
              onPressed: () => context.popRoute(),
              child: const Text(
                'Отменить',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
