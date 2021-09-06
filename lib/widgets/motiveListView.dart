import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motiveGSv2/data/infos.dart';
import 'package:motiveGSv2/utils/design.dart';
import 'package:motiveGSv2/provider/motiveList.dart';
import 'package:motiveGSv2/models/motives.dart';

import 'package:motiveGSv2/screens/homeMotive.dart';
import 'package:motiveGSv2/widgets/popupDetails.dart';
import 'package:motiveGSv2/widgets/timeContainer.dart';
import 'package:provider/provider.dart';

import 'addWidget.dart';

class MotiveListView extends StatefulWidget {
  const MotiveListView({
    Key key,
    @required this.screenSize,
  }) : super(key: key);
  final Size screenSize;

  @override
  _MotiveListViewState createState() => _MotiveListViewState();
}

int _chosenPage = 0;

class _MotiveListViewState extends State<MotiveListView> {
  @override
  Widget build(BuildContext context) {
    final Motives motivesData = Provider.of<Motives>(context);
    final List<Motive> motives = motivesData.items;
    final FirebaseAuth authFirebase = FirebaseAuth.instance;
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        SizedBox(
          height: 35,
          width: widget.screenSize.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: studentAccoms.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _chosenPage = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _chosenPage == index ? null : Colors.white,
                      gradient: _chosenPage == index ? blueGradient : null,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: _chosenPage != index
                          ? Border.all(color: blue1)
                          : null,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          '${motives.where((element) => element.accomLocation == index).toList().length} in ${studentAccoms[index]}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: _chosenPage == index ? Colors.white : blue1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: motives
                  .where(
                      (Motive element) => element.accomLocation == _chosenPage)
                  .toList()
                  .isEmpty
              ? 140
              : ((motives
                          .where((Motive element) =>
                              element.accomLocation == _chosenPage)
                          .toList()
                          .length) *
                      114) +
                  60.toDouble(),
          width: widget.screenSize.width,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: motives
                    .where((Motive i) => i.accomLocation == _chosenPage)
                    .toList()
                    .length +
                1,
            itemBuilder: (BuildContext context, int indexMotives) {
              if (motives
                  .where((Motive i) => i.accomLocation == _chosenPage)
                  .toList()
                  .isEmpty) {
                return SizedBox(
                  width: widget.screenSize.width,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'No motives at the moment  ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const Icon(Icons.sentiment_very_dissatisfied),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AddPlus(
                        studentAccomNr: _chosenPage,
                      ),
                    ],
                  ),
                );
              } else if (indexMotives ==
                  motives
                      .where((Motive i) => i.accomLocation == _chosenPage)
                      .toList()
                      .length) {
                return SizedBox(
                  width: 80,
                  child: Center(
                    child: AddPlus(
                      studentAccomNr: _chosenPage,
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) => PopupDetails(
                        motive: motives
                            .where((Motive element) =>
                                element.accomLocation == _chosenPage)
                            .toList()[indexMotives],
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 14.0,
                              bottom: 14.0,
                              right: 14.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.black.withOpacity(.05),
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          motives
                                              .where((Motive i) =>
                                                  i.accomLocation ==
                                                  _chosenPage)
                                              .toList()[indexMotives]
                                              .title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Icon(
                                              Icons.location_pin,
                                              size: 18,
                                            ),
                                            Text(
                                              motives
                                                  .where((Motive i) =>
                                                      i.accomLocation ==
                                                      _chosenPage)
                                                  .toList()[indexMotives]
                                                  .locationDetails,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              motives
                                                          .where((Motive i) =>
                                                              i.accomLocation ==
                                                              _chosenPage)
                                                          .toList()[
                                                              indexMotives]
                                                          .description
                                                          .length >
                                                      22
                                                  ? motives
                                                      .where((Motive i) =>
                                                          i.accomLocation ==
                                                          _chosenPage)
                                                      .toList()[indexMotives]
                                                      .description
                                                      .replaceRange(
                                                          22,
                                                          motives
                                                              .where((Motive
                                                                      i) =>
                                                                  i.accomLocation ==
                                                                  _chosenPage)
                                                              .toList()[
                                                                  indexMotives]
                                                              .description
                                                              .length,
                                                          '...')
                                                  : motives
                                                      .where((Motive i) =>
                                                          i.accomLocation ==
                                                          _chosenPage)
                                                      .toList()[indexMotives]
                                                      .description,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            if (motives.any((Motive element) =>
                                                element.userID ==
                                                authFirebase.currentUser.uid))
                                              motives[motives.indexWhere((Motive
                                                                  element) =>
                                                              element.userID ==
                                                              authFirebase
                                                                  .currentUser
                                                                  .uid)]
                                                          .userID ==
                                                      motives
                                                          .where((Motive i) =>
                                                              i.accomLocation ==
                                                              _chosenPage)
                                                          .toList()[
                                                              indexMotives]
                                                          .userID
                                                  ? Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black87,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        CupertinoIcons
                                                            .person_fill,
                                                        color: Colors.black87,
                                                        size: 18,
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            else
                                              const SizedBox(),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            TimeContainer(
                                              displayedTime: motives
                                                  .where((Motive i) =>
                                                      i.accomLocation ==
                                                      _chosenPage)
                                                  .toList()[indexMotives]
                                                  .startTime,
                                              gradient: blueGradient,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
