import 'package:flutter/material.dart';

class ButtonMain extends StatefulWidget {
  const ButtonMain({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.color,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final Color color;

  @override
  _ButtonMainState createState() => _ButtonMainState();
}

class _ButtonMainState extends State<ButtonMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 90,
      ),
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 10,
            color: widget.color.withOpacity(.1),
          )
        ],
        border: Border.all(
          color: widget.color,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.icon,
              size: 17,
              color: widget.color,
            ),
            const SizedBox(width: 5),
            Text(
              widget.title,
              style: TextStyle(
                color: widget.color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
