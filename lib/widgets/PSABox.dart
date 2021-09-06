import 'package:flutter/material.dart';

class PSABox extends StatefulWidget {
  const PSABox({
    Key key,
    this.title,
    this.caption,
    this.icon,
    this.url,
    this.gradient,
  }) : super(key: key);
  final String title;
  final String caption;
  final String url;
  final IconData icon;
  final LinearGradient gradient;

  @override
  _PSABoxState createState() => _PSABoxState();
}

class _PSABoxState extends State<PSABox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: const BorderRadius.all(
          Radius.circular(13),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 10,
            color: const Color(0xFF0096FF).withOpacity(.03),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.caption,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
