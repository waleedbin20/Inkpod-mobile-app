import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String message;
  final String imageURI;
  EmptyMessage({this.message = "No data", this.imageURI = "assets/empty.png"});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Image.asset(
              "assets/empty.png",
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15))
        ],
      ),
    );
  }
}
