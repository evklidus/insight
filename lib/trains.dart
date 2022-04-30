import 'package:flutter/material.dart';

class TrainsScreen extends StatelessWidget {
  const TrainsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 77, 19, 87),
              Color.fromARGB(255, 58, 14, 66),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(111, 158, 158, 158),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Hero(
                      tag: 'Main title',
                      child: Material(
                        child: SizedBox(
                          width: 140.0,
                          child: Text(
                            'Силовая 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                    // Сделать блок с кол-вом тренировок, типов и направленностью, полупрозрачный
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
