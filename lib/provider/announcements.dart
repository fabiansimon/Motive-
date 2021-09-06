import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/announce.dart';
import '../utils/design.dart';

// const myIcons = <String, IconData>{
//   'coronavirus': Icons.coronavirus,
//   'alarm': CupertinoIcons.alarm,
//   'heart': Icons.favorite,
//   'at_sign': CupertinoIcons.at_circle,
// };

class Announcements with ChangeNotifier {
  final List<Announcement> _items = <Announcement>[
    Announcement(
      title: 'Coronavirus',
      caption: 'Stay safe and check out current measures',
      url: 'https://www.gold.ac.uk/staff-students/info/coronavirus/',
      icon: Icons.coronavirus,
      gradient: blueGradient,
    ),
    Announcement(
      title: 'Rent Strike',
      caption: 'Stay up to date to the ongoing rent strike',
      url:
          'https://www.goldsmithssu.org/news/article/6013/Goldsmiths-students-call-for-a-January-rent-strike/',
      icon: CupertinoIcons.alarm,
      gradient: redGradient,
    ),
    Announcement(
      title: 'Support',
      caption:
          'Do you want to follow or support the creator of this app? Click me',
      url: 'https://www.instagram.com/fabianssimon',
      icon: Icons.favorite,
      gradient: greenGradient,
    ),
  ];

  List<Announcement> get items {
    return [..._items];
  }
}
