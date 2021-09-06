import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motiveGSv2/utils/design.dart';

import 'package:motiveGSv2/utils/authentication_service.dart';
import 'package:motiveGSv2/widgets/signInField.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class OpenScreen extends StatefulWidget {
  @override
  _OpenScreenState createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = <String, String>{
    'email': '',
    'password': '',
  };

  final FirebaseAuth auth = FirebaseAuth.instance;

  Timer authTimer;

  bool _activateField1 = false;
  bool _activateField2 = false;
  bool _activateField3 = false;

  bool _isVerifying = false;
  bool _isLoading = false;
  bool _obscureText = true;

  void _showErrorDialog(String message) async {
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

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  void dispose() {
    if (_isVerifying) {
      authTimer.cancel();
      setState(() {
        _isVerifying = false;
      });
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: _isVerifying
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CupertinoActivityIndicator(),
                  const SizedBox(height: 10),
                  const Text(
                    "Check your Junk-Folder (It's not spam) \nto verify yourself",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      if (auth.currentUser != null) {
                        auth.currentUser.delete();
                      }
                      setState(() {
                        _isVerifying = false;
                      });
                      authTimer.cancel();
                    },
                    child: const Icon(
                      CupertinoIcons.xmark_circle,
                      size: 30,
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                if (FocusScope.of(context).isFirstFocus) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _authMode == AuthMode.Login
                          ? MediaQuery.of(context).size.height * .35
                          : MediaQuery.of(context).size.height * .3,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Lottie.asset(
                            'assets/diese.json',
                            repeat: false,
                            fit: BoxFit.fitWidth,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Text(
                                _authMode == AuthMode.Login
                                    ? 'WELCOME BACK!'
                                    : 'WELCOME TO MOTIVE!',
                                style: const TextStyle(
                                  fontSize: 17,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 30),
                              SignInField(
                                chosen: _activateField1,
                                icon: CupertinoIcons.mail,
                                textField: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  cursorColor: Colors.black,
                                  autocorrect: false,
                                  onTap: () {
                                    setState(() {
                                      _activateField1 = true;
                                      _activateField2 = false;
                                      _activateField3 = false;
                                    });
                                  },
                                  onEditingComplete: () {
                                    _activateField1 = false;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty ||
                                        !value.contains('@gold.ac.uk')) {
                                      return 'Email must end with @gold.ac.uk';
                                    }
                                  },
                                  onSaved: (String value) {
                                    _authData['email'] = value.trim();
                                  },
                                  onFieldSubmitted: (String value) {
                                    if (FocusScope.of(context).isFirstFocus) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    }
                                  },
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                      fontSize: 10,
                                    ),
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.only(top: 8),
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    counter: const SizedBox(),
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: _activateField1
                                          ? Colors.black87
                                          : Colors.black.withOpacity(.4),
                                      // color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  SignInField(
                                    chosen: _activateField2,
                                    icon: CupertinoIcons.lock_fill,
                                    textField: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          _activateField2 = true;
                                          _activateField1 = false;
                                          _activateField3 = false;
                                        });
                                      },
                                      onEditingComplete: () {
                                        setState(() {
                                          _activateField2 = false;
                                        });
                                      },
                                      controller: _password1Controller,
                                      obscureText: _obscureText,
                                      cursorColor: Colors.black,
                                      validator: (String value) {
                                        if (value.isEmpty || value.length < 6) {
                                          return 'Invalid Passwordd';
                                        }
                                      },
                                      onSaved: (String newValue) {
                                        _authData['password'] = newValue.trim();
                                      },
                                      onFieldSubmitted: (String value) {
                                        if (FocusScope.of(context)
                                            .isFirstFocus) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        }
                                      },
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(
                                          fontSize: 10,
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.only(top: 8),
                                        border: InputBorder.none,
                                        hintText: 'Password',
                                        counter: const SizedBox(),
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: _activateField2
                                              ? Colors.black87
                                              : Colors.black.withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: GestureDetector(
                                      onTapDown: (TapDownDetails details) {
                                        setState(() {
                                          _obscureText = false;
                                        });
                                      },
                                      onTapUp: (TapUpDetails details) {
                                        setState(() {
                                          _obscureText = true;
                                        });
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _obscureText = true;
                                        });
                                      },
                                      child: Icon(
                                        CupertinoIcons.eye_fill,
                                        size: 20,
                                        color: _activateField2
                                            ? Colors.black87
                                            : Colors.black.withOpacity(.4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: _authMode == AuthMode.Login ? 0 : 20,
                              ),
                              if (_authMode == AuthMode.Signup)
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    SignInField(
                                      chosen: _activateField3,
                                      icon: CupertinoIcons.lock_fill,
                                      textField: TextFormField(
                                        onTap: () {
                                          setState(() {
                                            _activateField3 = true;
                                            _activateField1 = false;
                                            _activateField2 = false;
                                          });
                                        },
                                        onEditingComplete: () {
                                          setState(() {
                                            _activateField3 = false;
                                          });
                                        },
                                        controller: _password2Controller,
                                        obscureText: _obscureText,
                                        cursorColor: Colors.black,
                                        validator: _authMode == AuthMode.Signup
                                            ? (String value) {
                                                if (value !=
                                                    _password1Controller.text) {
                                                  return 'Passwords do not match';
                                                }
                                              }
                                            : null,
                                        onSaved: (String newValue) {
                                          _authData['password'] =
                                              newValue.trim();
                                        },
                                        onFieldSubmitted: (String value) {
                                          if (FocusScope.of(context)
                                              .isFirstFocus) {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }
                                        },
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                            fontSize: 10,
                                          ),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.only(top: 8),
                                          border: InputBorder.none,
                                          hintText: 'Repeat Password',
                                          counter: const SizedBox(),
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: _activateField3
                                                ? Colors.black87
                                                : Colors.black.withOpacity(.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: GestureDetector(
                                        onTapDown: (TapDownDetails details) {
                                          setState(() {
                                            _obscureText = false;
                                          });
                                        },
                                        onTapUp: (TapUpDetails details) {
                                          setState(() {
                                            _obscureText = true;
                                          });
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            _obscureText = true;
                                          });
                                        },
                                        child: Icon(
                                          CupertinoIcons.eye_fill,
                                          size: 20,
                                          color: _activateField3
                                              ? Colors.black87
                                              : Colors.black.withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                const SizedBox(),
                              const SizedBox(height: 40),
                              if (_isLoading)
                                const CupertinoActivityIndicator()
                              else
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _submit();
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: blue1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _authMode == AuthMode.Login
                                              ? 'LOG IN'
                                              : 'SIGN UP',
                                          style: TextStyle(
                                            color: blue1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Text(
                                _authMode == AuthMode.Login
                                    ? "Don't have an account yet?"
                                    : 'Already have an account?',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 52.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _switchAuthMode();
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.3),
                                          blurRadius: 6,
                                        )
                                      ],
                                      color: Colors.black87,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _authMode == AuthMode.Login
                                            ? 'SIGN UP INSTEAD'
                                            : 'LOG IN INSTEAD',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .05,
                              ),
                              if (_authMode == AuthMode.Login)
                                GestureDetector(
                                  onTap: () async {
                                    print('tapped');
                                    if (_emailController.text.isNotEmpty) {
                                      try {
                                        await auth
                                            .sendPasswordResetEmail(
                                                email: _emailController.text)
                                            .then((_) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Icon(
                                                    CupertinoIcons.paperplane),
                                                const Text(
                                                  '  Email sent! Check your inbox',
                                                ),
                                              ],
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                          ));
                                        });
                                      } on FirebaseAuthException catch (e) {
                                        print(e.message);
                                        _showErrorDialog(
                                            'There is no user record corresponding to this email, please sign up first');
                                      }
                                    } else {
                                      _showErrorDialog(
                                          'Need your email to reset your password');
                                    }
                                  },
                                  child: const Text(
                                    'Forgot your password?',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      //invalid
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        //Log user in

        final FirebaseAuth auth = FirebaseAuth.instance;

        await context
            .read<AuthenticationService>()
            .signIn(
              email: _authData['email'],
              password: _authData['password'],
            )
            .then((_) {
          if (!auth.currentUser.emailVerified) {
            auth.currentUser.delete();
            _showErrorDialog(
                'There is no user record corresponding to this email, please sign up');
          }
        }).catchError((dynamic e) {
          _showErrorDialog(e.toString());
        });
      } else {
        //Sign user up

        await context
            .read<AuthenticationService>()
            .signUp(
              email: _authData['email'],
              password: _authData['password'],
            )
            .then((_) {
          setState(() {
            _isVerifying = true;
          });
          final User user = auth.currentUser;
          user.sendEmailVerification();
          authTimer =
              Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
            await context
                .read<AuthenticationService>()
                .checkEmailVerified()
                .catchError((dynamic error) {
              _showErrorDialog(error.toString());
            });
          });
        });
      }
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
