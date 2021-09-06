import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motiveGSv2/utils/design.dart';

class TimeContainer extends StatefulWidget {
  const TimeContainer({
    Key key,
    @required this.displayedTime,
    @required this.gradient,
  });

  final String displayedTime;
  final LinearGradient gradient;

  @override
  _TimeContainerState createState() => _TimeContainerState();
}

class _TimeContainerState extends State<TimeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.time,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                widget.displayedTime,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
