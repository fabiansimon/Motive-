import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInField extends StatefulWidget {
  const SignInField({
    Key key,
    this.textField,
    this.icon,
    this.chosen,
  }) : super(key: key);
  final IconData icon;
  final TextFormField textField;
  final bool chosen;

  @override
  _SignInFieldState createState() => _SignInFieldState();
}

class _SignInFieldState extends State<SignInField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.chosen ? Colors.black87 : Colors.black.withOpacity(.4),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              widget.icon,
              size: 20,
              color:
                  widget.chosen ? Colors.black87 : Colors.black.withOpacity(.4),
            ),
          ),
          Expanded(
            child: widget.textField,
          ),
        ],
      ),
    );
  }
}
