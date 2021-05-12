import 'package:flutter/material.dart';

class SingleDot extends StatelessWidget {
  bool isActive;
  SingleDot(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
