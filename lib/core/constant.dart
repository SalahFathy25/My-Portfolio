import 'package:flutter/material.dart';

import '../screens/certificates_screen.dart';
import '../screens/projects_screen.dart';

final homeKey = GlobalKey();
final aboutKey = GlobalKey();
final projectsKey = GlobalKey();
final certificatesKey = GlobalKey();
final contactKey = GlobalKey();

class Constants {
  static const String myName = "Salah Fathy";
  static const String myImage = "assets/salah_fathy.png";
  static const String gitHubLink = "https://github.com/SalahFathy25";
  static const String linkedInLink =
      "https://www.linkedin.com/in/salah-fathy-2219b525b/";
  static const String myEmail = "sf116170@gmail.com";
  static const String myPhone = "+201061420169";
  static const String myAddress = '10th Of Ramadan, Egypt';
  static const String myCVAsset = 'assets/my_cv.pdf';
  static const String myCVLink =
      'https://drive.google.com/file/d/1tVfcGNC4H7EEt4bUCgpx0v5jsH0jBxsa/view?usp=sharing';

  static List<Certificate> certificates = [
    Certificate(
      name: 'Freelancer',
      issuer: 'ITIDIA Gigs',
      date: '2025',
      image: 'assets/certificate_1.png',
      skills: ['Freelancing'],
    ),
  ];

  static final skills = [
    {'name': 'Flutter/Dart', 'level': 0.85},
    {'name': 'Firebase', 'level': 0.80},
    {'name': 'REST API', 'level': 0.80},
    {'name': 'State Management', 'level': 0.80},
    {'name': 'UI/UX Design', 'level': 0.90},
    {'name': 'Git & GitHub', 'level': 0.85},
  ];

  static List<Project> projects = [
    Project(
      name: 'QR Scanner & Generator App',
      description:
          'application to help people share contact information easily and conveniently by saving their contact information and then sharing it with others via QR code. They can also scan any QR code through the application.',
      technologies: ['Flutter', 'Cubit', 'Qr Scan'],
      githubUrl: 'https://github.com/SalahFathy25/qr_scanner',
    ),
    Project(
      name: 'To-do App',
      description:
          'Built a task management app using Flutter with local state management. Features include adding, deleting, and marking tasks as completed, with a clean and user-friendly interface.',
      technologies: [
        'Flutter',
        'Cubit',
        'Localization',
        'Light & Dark Mode',
        'Local Storage',
      ],
      githubUrl: 'https://github.com/SalahFathy25/todo-App',
    ),
    Project(
      name: 'Weather App',
      description:
          'Developed a clean and responsive weather application using Flutter and OpenWeatherMap API. Displays real-time weather data based on user location with intuitive UI and smooth user experience.',
      technologies: ['Flutter', 'Cubit', 'Api'],
      githubUrl: 'https://github.com/SalahFathy25/Weather_app',
    ),
  ];
}
