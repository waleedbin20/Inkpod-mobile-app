import 'package:app/config/WidgetSpace.dart';
import 'package:flutter/material.dart';

class BrandButton extends StatelessWidget {
  final String buttonText;
  final Function onTap;
  const BrandButton({Key? key, required this.buttonText, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Text(buttonText),
          color: Colors.red,
          textColor: Colors.white,
          height: 50,
          onPressed: () => onTap()),
    );
  }
}
