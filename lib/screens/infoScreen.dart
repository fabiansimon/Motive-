import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motiveGSv2/data/infos.dart';
import 'package:motiveGSv2/utils/design.dart';
import 'package:motiveGSv2/models/infoScreenData.dart';
import 'package:motiveGSv2/widgets/buttonMain.dart';

import 'homeMotive.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Image(
          image: AssetImage(
            'assets/logo.png',
          ),
          height: 20,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              itemCount: 3,
              controller: _pageController,
              onPageChanged: (int value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemBuilder: (BuildContext ctxt, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image(
                        image: AssetImage(currentInfos[index].image),
                        height: MediaQuery.of(context).size.height * .35,
                      ),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          currentInfos[index].title,
                          style: const TextStyle(
                            height: 1.4,
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_currentPage == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) => HomeMotive(),
                          ),
                        );
                      } else {
                        _currentPage += 1;
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutQuart,
                        );
                      }
                      ;
                    });
                  },
                  child: ButtonMain(
                    icon: CupertinoIcons.arrow_right,
                    title: 'next',
                    color: blue1,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    currentInfos.length,
                    (int i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _currentPage
                                ? Colors.black.withOpacity(.8)
                                : Colors.black.withOpacity(.3),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
