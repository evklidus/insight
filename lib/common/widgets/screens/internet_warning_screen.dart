import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:insight/common/di/locator_service.dart';
import 'package:insight/common/http/network_info.dart';

class InternetWarningScreen extends StatefulWidget {
  const InternetWarningScreen({Key? key, required this.onResult})
      : super(key: key);

  final Function(bool result) onResult;

  @override
  State<InternetWarningScreen> createState() => _InternetWarningScreenState();
}

class _InternetWarningScreenState extends State<InternetWarningScreen> {
  final networkInfo = getIt.get<NetworkInfo>();

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
                final hasConnection = await networkInfo.isConnected;
                if (hasConnection) {
                  widget.onResult(true);
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
