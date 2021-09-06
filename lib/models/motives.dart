import 'package:flutter/material.dart';

class Motive with ChangeNotifier {
  String id;
  String title;
  String description;
  String locationDetails;
  int accomLocation;
  String startTime;
  String userID;
  String phoneNr;

  Motive({
    @required this.id,
    @required this.title,
    @required this.startTime,
    @required this.locationDetails,
    @required this.accomLocation,
    @required this.description,
    @required this.userID,
    this.phoneNr,
  });
}

List<String> categoriesType = [
  "Party",
  "Chill-session",
  "Pre-Game",
  "Game Night",
  "Other",
];

List<String> studentAccoms = [
  "Chesterman House",
  "Ewen Henderson",
  "Loring Hall",
  "Quantum Court",
  "Raymont Hall",
  "Surrey House",
  "Town Hall Camberwell",
  "Other",
];
