import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motiveGSv2/data/infos.dart';
import 'package:motiveGSv2/utils/design.dart';
import 'package:motiveGSv2/provider/motiveList.dart';
import 'package:motiveGSv2/models/motives.dart';
import 'package:motiveGSv2/screens/homeMotive.dart';

import 'package:motiveGSv2/widgets/timeContainer.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'buttonMain.dart';

class PopupDetails extends StatelessWidget {
  const PopupDetails({
    Key key,
    @required this.motive,
  }) : super(key: key);

  final Motive motive;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth authFirebase = FirebaseAuth.instance;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * .95,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            motive.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              if (motive.userID == authFirebase.currentUser.uid)
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black87,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.person_fill,
                                    color: Colors.black87,
                                    size: 16,
                                  ),
                                )
                              else
                                const SizedBox(),
                              const SizedBox(
                                width: 3,
                              ),
                              TimeContainer(
                                displayedTime: motive.startTime.toString(),
                                gradient: blueGradient,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_pin,
                            size: 18,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${studentAccoms[motive.accomLocation]}, ${motive.locationDetails}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: motive.phoneNr != '%%' ? 6 : 0,
                      ),
                      if (motive.phoneNr != '%%')
                        GestureDetector(
                          onTap: () async {
                            final String url = 'tel://${motive.phoneNr}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not lauunch $url';
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.phone,
                                size: 18,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                motive.phoneNr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox(),
                      const Divider(
                        color: Color(
                          0xFFE1E1E1,
                        ),
                        thickness: 1,
                        height: 30,
                        endIndent: 10,
                        indent: 10,
                      ),
                      Text(
                        motive.description,
                        style: const TextStyle(
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    final String url =
                                        'tel://' + motive.phoneNr;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not lauunch $url';
                                    }
                                  },
                                  child: motive.phoneNr != '%%'
                                      ? ButtonMain(
                                          icon: CupertinoIcons.phone,
                                          title: 'call',
                                          color: green1,
                                        )
                                      : const SizedBox()),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Share.share(
                                    "Hey! I'm going to a " +
                                        motive.title +
                                        ' in ' +
                                        studentAccoms[motive.accomLocation] +
                                        ', ' +
                                        motive.locationDetails +
                                        '.' +
                                        '\nIt started at ' +
                                        motive.startTime.toString() +
                                        ' and the host said in the description of the event: ' +
                                        motive.description +
                                        '.' +
                                        "\nHope I'll see you there!",
                                  );
                                },
                                child: ButtonMain(
                                  icon: CupertinoIcons.share,
                                  title: 'share',
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
