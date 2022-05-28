import 'package:m_sport/models/program.dart';
import 'package:m_sport/models/training.dart';

class Data {
  final List<Program> programs = [
    Program(
      name: 'Силовая 1',
      imageUrl: 'https://cdn.mos.cms.futurecdn.net/KLZwUWe4JwyyXY7pV7CpaU.jpg',
      trainings: [
        Training(
          name: 'Грудь + бицепсы',
          videoUrl:
              'https://player.vimeo.com/external/438451071.hd.mp4?s=863dcc7f2bd294d7968b25a2a867bd0ca1b6522e&profile_id=175&oauth2_token_id=57447761',
        ),
      ],
    ),
  ];
}
