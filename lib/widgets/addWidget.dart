import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MotiveAddScreen.dart';

class AddPlus extends StatelessWidget {
  const AddPlus({
    Key key,
    @required this.studentAccomNr,
  }) : super(key: key);
  final int studentAccomNr;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return AddMotiveScreen(
              studentAccomNr: studentAccomNr,
            );
          },
        );
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(.07),
            ),
          ],
          color: Colors.white,
        ),
        child: const Icon(
          CupertinoIcons.add_circled,
        ),
      ),
    );
  }
}
