import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Announcement {
  String title;
  String caption;
  String url;
  IconData icon;
  LinearGradient gradient;

  Announcement({
    this.title,
    this.caption,
    this.icon,
    this.url,
    this.gradient,
  });
}
