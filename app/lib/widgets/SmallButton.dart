import 'package:app/config/WidgetSpace.dart';
import 'package:flutter/material.dart';

class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final Function onClick;

  const SquareIconButton({Key? key, required this.icon, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        padding: EdgeInsets.all(15),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
