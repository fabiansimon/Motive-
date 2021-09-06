import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:motiveGSv2/data/infos.dart';
import 'package:motiveGSv2/utils/design.dart';
import 'package:motiveGSv2/provider/motiveList.dart';
import 'package:motiveGSv2/models/motives.dart';
import 'package:motiveGSv2/screens/homeMotive.dart';
import 'package:provider/provider.dart';

import 'buttonMain.dart';

class AddMotiveScreen extends StatefulWidget {
  const AddMotiveScreen({
    Key key,
    @required this.studentAccomNr,
  }) : super(key: key);
  final int studentAccomNr;

  @override
  _AddMotiveScreenState createState() => _AddMotiveScreenState();
}

class _AddMotiveScreenState extends State<AddMotiveScreen> {
  final TextEditingController _studentAccomController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int _accomTranslate;
  bool _isLoading = false;
  bool _initState = false;

  @override
  void didChangeDependencies() {
    if (_initState == false) {
      if (widget.studentAccomNr == studentAccoms.length + 1) {
      } else {
        _studentAccomController.text = studentAccoms[widget.studentAccomNr];
        _accomTranslate = widget.studentAccomNr;
        _initState = true;
      }
    }
    super.didChangeDependencies();
  }

  Future<void> _showErrorDialog<Null>(String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text('Oops...'),
            content: SingleChildScrollView(
              child: Text(message),
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
            content: SingleChildScrollView(
              child: Text(message),
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

  void _showPicker(BuildContext ctxt, List<String> list) {
    showCupertinoModalPopup(
      context: ctxt,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: 200,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 35,
          scrollController: widget.studentAccomNr != studentAccoms.length + 1
              ? FixedExtentScrollController(initialItem: widget.studentAccomNr)
              : FixedExtentScrollController(),
          onSelectedItemChanged: (int value) {
            setState(() {
              if (list == studentAccoms) {
                _studentAccomController.text = studentAccoms[value];
                _accomTranslate = value;
              } else {
                _categoryController.text = categoriesType[value];
              }
            });
          },
          children: List<Widget>.generate(
            list.length,
            (int index) {
              return Text(list[index]);
            },
          ),
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext ctxt) {
    showCupertinoModalPopup(
      context: ctxt,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: 200,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          mode: CupertinoDatePickerMode.time,
          use24hFormat: true,
          onDateTimeChanged: (DateTime value) {
            setState(() {
              String parsedTime = value.toString().replaceRange(0, 11, '');
              parsedTime = parsedTime.replaceRange(5, 12, '');
              _timeController.text = parsedTime;
            });
          },
        ),
      ),
    );
  }

  Future<void> _addMotive() async {
    final FirebaseAuth authFirebase = FirebaseAuth.instance;
    final Motives motivesData = Provider.of<Motives>(context, listen: false);
    final List<Motive> motives = motivesData.items;

    if (motives.any(
        (Motive element) => element.userID == authFirebase.currentUser.uid)) {
      _showErrorDialog(
        'Sorry you can only create one Motive at the time',
      );
    } else {
      if (_studentAccomController.text.isNotEmpty &&
          _additionalInfoController.text.isNotEmpty &&
          _categoryController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _timeController.text.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        try {
          final FirebaseAuth authFirebase = FirebaseAuth.instance;

          await Provider.of<Motives>(context, listen: false)
              .addMotiveToProvider(
            Motive(
              accomLocation: _accomTranslate,
              locationDetails: _additionalInfoController.text,
              title: _categoryController.text,
              description: _descriptionController.text,
              startTime: _timeController.text.toString(),
              id: '100',
              userID: authFirebase.currentUser.uid,
              phoneNr:
                  _phoneController.text.isEmpty ? '%%' : _phoneController.text,
            ),
          );
        } catch (error) {
          await showDialog<Widget>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              if (Platform.isIOS) {
                return CupertinoAlertDialog(
                  title: const Text('Oops...'),
                  content: const SingleChildScrollView(
                    child: const Text('Sorry, something went wrong!'),
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
                    child: Text('Sorry, something went wrong!'),
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
        } finally {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        }

        setState(() {
          _studentAccomController.text = '';
          _additionalInfoController.text = '';
          _categoryController.text = '';
          _descriptionController.text = '';
          _timeController.text = '';
        });
        // print(motives.last.title);
      } else {
        _showErrorDialog(
            'You need to fill out all the fields to be able to submit it');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.xmark,
                        size: 20,
                      ),
                    ),
                  ),
                  const Text(
                    "What's the motive?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),
            const Divider(
              color: Color(
                0xFFE1E1E1,
              ),
              thickness: 1,
              height: 30,
              endIndent: 0,
              indent: 0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Where?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context, studentAccoms);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .05,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                          color: Color(0xFFECECEC),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                CupertinoIcons.house,
                                size: 18,
                                color: Color(0xFF656565),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  controller: _studentAccomController,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 8),
                                    border: InputBorder.none,
                                    hintText: 'Student Accomodation*',
                                    counter: SizedBox(),
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Color(0xFF656565),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * .05,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                        color: Color(0xFFECECEC),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.location_pin,
                              size: 18,
                              color: Color(0xFF656565),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.done,
                                maxLength: 12,
                                autocorrect: false,
                                enableSuggestions: false,
                                controller: _additionalInfoController,
                                cursorColor: Colors.black,
                                textCapitalization: TextCapitalization.words,
                                cursorWidth: 1.3,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 8),
                                  border: InputBorder.none,
                                  hintText:
                                      'Additional Info (House/Flat/Room)*',
                                  counter: SizedBox(),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Color(0xFF656565),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * .05,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                        color: Color(0xFFECECEC),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.phone,
                              size: 18,
                              color: Color(0xFF656565),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.done,
                                maxLength: 14,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.phone,
                                controller: _phoneController,
                                cursorColor: Colors.black,
                                textCapitalization: TextCapitalization.words,
                                cursorWidth: 1.3,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 8),
                                  border: InputBorder.none,
                                  hintText: 'Phone number',
                                  counter: SizedBox(),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Color(0xFF656565),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: const Color(
                        0xFFE1E1E1,
                      ),
                      thickness: 1,
                      height: MediaQuery.of(context).size.height * .05,
                      endIndent: 0,
                      indent: 0,
                    ),
                    const Text(
                      'What?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context, categoriesType);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .05,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                          color: Color(0xFFECECEC),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                CupertinoIcons.pencil,
                                size: 20,
                                color: Color(0xFF656565),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  maxLength: 16,
                                  enabled: false,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.phone,
                                  controller: _categoryController,
                                  cursorColor: Colors.black,
                                  textCapitalization: TextCapitalization.words,
                                  cursorWidth: 1.3,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 8),
                                    border: InputBorder.none,
                                    hintText: 'Category*',
                                    counter: SizedBox(),
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Color(0xFF656565),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * .05,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                        color: Color(0xFFECECEC),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Color(0xFF656565),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.done,
                                maxLength: 100,
                                autocorrect: false,
                                enableSuggestions: false,
                                controller: _descriptionController,
                                cursorColor: Colors.black,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                cursorWidth: 1.3,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 8),
                                  border: InputBorder.none,
                                  hintText: 'Description*',
                                  counter: SizedBox(),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Color(0xFF656565),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: const Color(
                        0xFFE1E1E1,
                      ),
                      thickness: 1,
                      height: MediaQuery.of(context).size.height * .05,
                      endIndent: 0,
                      indent: 0,
                    ),
                    const Text(
                      'What?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _showTimePicker(context);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .05,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                color: Color(0xFFECECEC),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      CupertinoIcons.clock,
                                      size: 20,
                                      color: Color(0xFF656565),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        controller: _timeController,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.only(top: 8),
                                          border: InputBorder.none,
                                          hintText: 'Time*',
                                          counter: SizedBox(),
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            color: Color(0xFF656565),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            _timeController.text =
                                DateFormat.Hm().format(DateTime.now());
                          },
                          child: ButtonMain(
                            icon: CupertinoIcons.clock,
                            title: 'now',
                            color: green1,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _addMotive();
                        },
                        child: Center(
                          child: _isLoading
                              ? const CupertinoActivityIndicator()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            blurRadius: 10,
                                            color: blue1.withOpacity(.2),
                                          )
                                        ],
                                        border: Border.all(
                                          color: blue1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: blue1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight > 700 ? 10 : 0,
                                    ),
                                    if (screenHeight > 700)
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 45,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                            gradient: redGradient,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox(),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
