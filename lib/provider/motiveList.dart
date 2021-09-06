import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motiveGSv2/data/infos.dart';
import 'package:motiveGSv2/utils/http_exeption.dart';
import 'package:motiveGSv2/screens/homeMotive.dart';

import '../models/motives.dart';

class Motives with ChangeNotifier {
  Motives(
    this.authToken,
    this._items,
    this.userId,
  );
  List<Motive> _items = <Motive>[];

  final String authToken;
  final String userId;

  List<Motive> get items {
    return [..._items];
  }

  Future<void> fetchAndSetMotives() async {
    final FirebaseAuth authFirebase = FirebaseAuth.instance;

    String token;

    await authFirebase.currentUser.getIdToken().then(
          (String value) => token = value,
        );

    final String url =
        'https://motivegs-default-rtdb.firebaseio.com/motives.json?auth=$token';

    try {
      final http.Response response = await http.get(url);
      final Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Motive> loadedMotives = [];
      if (extractedData != null) {
        extractedData.forEach((String motiveID, dynamic motiveData) {
          loadedMotives.add(
            Motive(
              id: motiveID,
              title: motiveData['title'] as String,
              startTime: motiveData['startTime'] as String,
              locationDetails: motiveData['locationDetails'] as String,
              accomLocation: studentAccoms.indexWhere(
                  (String element) => element == motiveData['accomLocation']),
              description: motiveData['description'] as String,
              userID: motiveData['userId'] as String,
              phoneNr: motiveData['phoneNr'] as String,
            ),
          );
        });
        _items = loadedMotives;
      } else {
        _items = <Motive>[];
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addMotiveToProvider(Motive motive) async {
    final FirebaseAuth authFirebase = FirebaseAuth.instance;

    String token;

    await authFirebase.currentUser.getIdToken().then(
          (String value) => token = value,
        );

    final String url =
        'https://motivegs-default-rtdb.firebaseio.com/motives.json?auth=$token';
    try {
      final http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'title': motive.title,
            'description': motive.description,
            'locationDetails': motive.locationDetails,
            'accomLocation': studentAccoms[motive.accomLocation],
            'startTime': motive.startTime,
            'userId': motive.userID,
            'phoneNr': motive.phoneNr,
          },
        ),
      );
      final Motive newMotive = Motive(
          id: json.decode(response.body)['name'] as String,
          title: motive.title,
          startTime: motive.startTime,
          locationDetails: motive.locationDetails,
          accomLocation: motive.accomLocation,
          description: motive.description,
          userID: motive.userID,
          phoneNr: motive.phoneNr);

      _items.add(newMotive);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> removeMotiveFromProvider(String id) async {
    final FirebaseAuth authFirebase = FirebaseAuth.instance;

    String token;

    await authFirebase.currentUser.getIdToken().then(
          (String value) => token = value,
        );

    final String url =
        'https://motivegs-default-rtdb.firebaseio.com/motives/$id.json?auth=$token';
    final int existingMotiveIndex =
        _items.indexWhere((Motive motive) => motive.id == id);
    var existingMotive = _items[existingMotiveIndex];

    try {
      final http.Response response = await http.delete(url);
      _items.removeAt(existingMotiveIndex);
      notifyListeners();

      if (response.statusCode >= 400) {
        print('hey');
        _items.insert(existingMotiveIndex, existingMotive);
        notifyListeners();
        throw const HttpException('Could not delete motive, sorry');
      } else {
        existingMotive = null;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
