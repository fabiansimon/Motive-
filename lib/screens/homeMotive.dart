import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:motiveGSv2/data/infos.dart';
import 'package:motiveGSv2/models/announce.dart';
import 'package:motiveGSv2/models/motives.dart';
import 'package:motiveGSv2/utils/design.dart';

import 'package:motiveGSv2/provider/announcements.dart';

import 'package:motiveGSv2/utils/authentication_service.dart';
import 'package:motiveGSv2/provider/motiveList.dart';

import 'package:motiveGSv2/widgets/PSABox.dart';
import 'package:motiveGSv2/widgets/addWidget.dart';
import 'package:motiveGSv2/widgets/motiveListView.dart';
import 'package:motiveGSv2/widgets/popupDetails.dart';
import 'package:motiveGSv2/widgets/timeContainer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMotive extends StatefulWidget {
  @override
  _HomeMotiveState createState() => _HomeMotiveState();
}

bool _isCalled = false;

class _HomeMotiveState extends State<HomeMotive> {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _deleteMotive() async {
    final Motives motivesData = Provider.of<Motives>(context, listen: false);
    final List<Motive> motives = motivesData.items;
    final FirebaseAuth authFirebase = FirebaseAuth.instance;

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Motives>(context, listen: false)
          .removeMotiveFromProvider(motives
              .firstWhere(
                  (Motive i) => i.userID == authFirebase.currentUser.uid)
              .id)
          .then((_) {
        setState(() {
          _isCalled = false;
        });
      }).catchError((error) {});
      // ignore: use_build_context_synchronously
      await Provider.of<Motives>(context, listen: false)
          .fetchAndSetMotives()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((dynamic error) {
        print(error);
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      await showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text('Oops...'),
              content: const SingleChildScrollView(
                child: const Text("Sorry, couldn't delete your motive"),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: const Text('Oops...'),
              content: const SingleChildScrollView(
                child: const Text("Sorry, couldn't delete your motive"),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          }
        },
      );
    }
  }

  bool _initState = true;
  bool _isLoading;
  int _currentPage = 0;
  String message = 'Getting current motives';

  @override
  void initState() {
    final FirebaseAuth authFirebase = FirebaseAuth.instance;
    print('Email: ${authFirebase.currentUser.email}');
    print('User Id: ${authFirebase.currentUser.uid}');
    print('Email Verified ${authFirebase.currentUser.emailVerified}');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Motives>(context).fetchAndSetMotives().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initState = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Motive> motives = Provider.of<Motives>(context).items;
    final Announcements announceData = Provider.of<Announcements>(context);
    final List<Announcement> announcements = announceData.items;
    final FirebaseAuth authFirebase = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                if (Platform.isIOS) {
                  return CupertinoAlertDialog(
                    title: const Text('Wait!'),
                    content: const SingleChildScrollView(
                      child: const Text('Are you sure you want to log out?'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Provider.of<Auth>(context, listen: false).logout();
                          context.read<AuthenticationService>().signOut();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                } else {
                  return AlertDialog(
                    title: const Text('Wait!'),
                    content: const Text(
                      'Are you sure you want to log out?',
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          context.read<AuthenticationService>().signOut();
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: Text('Yes'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: Text('No'),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          },
          child: Container(
            color: Colors.transparent,
            child: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ),
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            height: 20,
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .14,
          ),
        ],
      ),
      body: _isLoading == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CupertinoActivityIndicator(),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                LiquidPullToRefresh(
                  animSpeedFactor: 10,
                  backgroundColor: Colors.white,
                  showChildOpacityTransition: false,
                  color: blue2,
                  springAnimationDurationInMilliseconds: 400,
                  borderWidth: 1,
                  height: 60,
                  onRefresh: () async {
                    return Provider.of<Motives>(context, listen: false)
                        .fetchAndSetMotives()
                        .then((_) {
                      setState(() {
                        _isLoading = false;
                      });
                    }).catchError((dynamic error) {
                      print(error);
                    });
                    // _refreshScreen(context);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 18.0,
                                  right: 18.0,
                                  top: 18.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Text(
                                          'Hey there!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.black87,
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Looking for a motive?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black45,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        )
                                      ],
                                    ),
                                    AddPlus(
                                      studentAccomNr: studentAccoms.length + 1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .13,
                                      width: double.infinity,
                                      child: PageView.builder(
                                        itemCount: announcements.length,
                                        onPageChanged: (int value) {
                                          setState(() {
                                            _currentPage = value;
                                          });
                                        },
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: GestureDetector(
                                              onTap: () => _launchURL(
                                                  announcements[index].url),
                                              child: PSABox(
                                                title:
                                                    announcements[index].title,
                                                caption: announcements[index]
                                                    .caption,
                                                gradient: announcements[index]
                                                    .gradient,
                                                icon: announcements[index].icon,
                                                url: announcements[index].url,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.015,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List<Widget>.generate(
                                        announcements.length,
                                        (int i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 4.0,
                                            ),
                                            child: Container(
                                              height: 6,
                                              width: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: i == _currentPage
                                                    ? Colors.black
                                                        .withOpacity(.8)
                                                    : Colors.black
                                                        .withOpacity(.3),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: const Color(0xFFE1E1E1),
                            thickness: 1,
                            height: MediaQuery.of(context).size.height * 0.03,
                            endIndent: 30,
                            indent: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 22.0,
                              top: 12,
                              right: 22.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${motives.length} active motives',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: Colors.black87,
                                        letterSpacing: -.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          MotiveListView(
                            screenSize: MediaQuery.of(context).size,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (motives.any((Motive element) =>
                    element.userID == authFirebase.currentUser.uid))
                  AnimatedPositioned(
                    duration: _isCalled
                        ? const Duration(milliseconds: 200)
                        : Duration.zero,
                    right: _isCalled
                        ? MediaQuery.of(context).size.width * .05
                        : -(MediaQuery.of(context).size.width * 0.75),
                    bottom: MediaQuery.of(context).size.height * .05,
                    child: Dismissible(
                      key: UniqueKey(),
                      confirmDismiss: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          setState(() {
                            _isCalled = false;
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              if (Platform.isIOS) {
                                return CupertinoAlertDialog(
                                  title: const Text('Wait!'),
                                  content: const SingleChildScrollView(
                                    child: const Text(
                                        'Do you really want to delete your motive?'),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        _deleteMotive();
                                        Navigator.of(context).pop();
                                        return true;
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        return false;
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: const Text('Wait!'),
                                  content: const Text(
                                    'Do you really want to delete your motive?',
                                  ),
                                  actions: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _deleteMotive();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 8.0,
                                        ),
                                        child: Text('Yes'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 8.0,
                                        ),
                                        child: Text('No'),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (_isCalled) {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) => PopupDetails(
                                motive: motives.firstWhere(
                                  (Motive element) =>
                                      element.userID ==
                                      authFirebase.currentUser.uid,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              _isCalled = true;
                            });
                          }
                        },
                        child: Stack(
                          alignment: Alignment.centerRight,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .9,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      blurRadius: 20,
                                      color: Colors.black.withOpacity(.05),
                                    )
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(7),
                                  )),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    width:
                                        MediaQuery.of(context).size.width * .15,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(11),
                                        bottomLeft: Radius.circular(11),
                                      ),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.person_fill,
                                      color: Colors.black87,
                                      size: 25,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 10,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0,
                                          vertical: 6.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              motives
                                                  .firstWhere(
                                                    (Motive i) =>
                                                        i.userID ==
                                                        authFirebase
                                                            .currentUser.uid,
                                                  )
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
                                                  studentAccoms[motives
                                                          .firstWhere((Motive
                                                                  i) =>
                                                              i.userID ==
                                                              authFirebase
                                                                  .currentUser
                                                                  .uid)
                                                          .accomLocation] +
                                                      ', ' +
                                                      motives
                                                          .firstWhere(
                                                            (Motive i) =>
                                                                i.userID ==
                                                                authFirebase
                                                                    .currentUser
                                                                    .uid,
                                                          )
                                                          .locationDetails,
                                                  overflow: TextOverflow.clip,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
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
                            Positioned(
                              right: MediaQuery.of(context).size.width * .04,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      if (Platform.isIOS) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Wait!'),
                                          content: const SingleChildScrollView(
                                            child: const Text(
                                              'Do you really want to delete your motive?',
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                _deleteMotive();
                                                Navigator.of(context).pop();
                                                return true;
                                              },
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                return false;
                                              },
                                              child: const Text('No'),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return AlertDialog(
                                          title: const Text('Wait!'),
                                          content: const Text(
                                            'Do you really want to delete your motive?',
                                          ),
                                          actions: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                _deleteMotive();
                                                Navigator.of(context).pop();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 8.0,
                                                ),
                                                child: const Text('Yes'),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 8.0,
                                                ),
                                                child: Text('No'),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        blurRadius: 6,
                                        color: Colors.black.withOpacity(.1),
                                      ),
                                    ],
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.trash,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: -17,
                              child: TimeContainer(
                                displayedTime: motives[motives.indexWhere(
                                        (Motive element) =>
                                            element.userID ==
                                            authFirebase.currentUser.uid)]
                                    .startTime,
                                gradient: blueGradient,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
    );
  }
}
