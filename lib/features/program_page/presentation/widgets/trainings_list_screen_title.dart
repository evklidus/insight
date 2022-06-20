import 'package:flutter/material.dart';
import 'package:m_sport/components/boxes.dart';
import 'package:m_sport/components/rounded_back_icon.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';

class TrainingsListScreenTitle extends StatelessWidget {
  // ignore: unused_element
  const TrainingsListScreenTitle(this.program, {Key? key, this.onTap}) : super(key: key);

  final ProgramEntity program;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          RoundedBackIcon(
            onTap: () {
              onTap;
            },
          ),
          const WBox(10),
          Hero(
            tag: program.id,
            child: Material(
              child: SizedBox(
                width: 180,
                child: Text(
                  program.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
