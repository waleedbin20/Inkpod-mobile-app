import 'package:app/widgets/BrandButton.dart';
import 'package:app/widgets/CustomTextField.dart';
import 'package:app/widgets/PageHeader.dart';
import 'package:flutter/material.dart';

class BecomeModerator extends StatefulWidget {
  const BecomeModerator({Key? key}) : super(key: key);

  @override
  _BecomeModeratorState createState() => _BecomeModeratorState();
}

class _BecomeModeratorState extends State<BecomeModerator> {
  final moderatorTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SliverHeading(heading: "Moderator Sign Up"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CustomTextField(
                textController: moderatorTextController,
                inputHint: "Why do you want to be a moderator?",
                isMultiline: true,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BrandButton(
                buttonText: "Submit",
                onTap: () {
                  ;
                }),
          )
        ],
      ),
    );
  }
}
