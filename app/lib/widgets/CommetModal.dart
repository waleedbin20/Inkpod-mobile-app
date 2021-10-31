import 'package:app/config/WidgetSpace.dart';
import 'package:app/widgets/CustomTextField.dart';
import 'package:app/widgets/EmptyMessage.dart';
import 'package:app/widgets/PageHeader.dart';
import 'package:app/widgets/SmallButton.dart';
import 'package:flutter/material.dart';

class CommentModal extends StatefulWidget {
  final postId;
  const CommentModal({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentModalState createState() => _CommentModalState();
}

Widget CommentArea() => Expanded(
        child: Scrollbar(
            child: CustomScrollView(
      slivers: [
        EmptyMessage(
          message: "No comments yet",
        )
      ],
    )));

class _CommentModalState extends State<CommentModal> {
  TextEditingController commentController = new TextEditingController();

  Widget CommentHeader(context) => InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [PageHeading("Comments"), Icon(Icons.keyboard_arrow_down)],
        ),
      );

  Widget CommentInput(textFieldWidth) => Row(
        children: [
          Container(
            width: textFieldWidth,
            child: CustomTextField(
                textController: commentController,
                inputHint: "Write a comment..."),
          ),
          SquareIconButton(
              icon: Icons.send,
              onClick: () {
                print(commentController.text);
              })
        ],
      );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(5),
      height: screenHeight * .9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommentHeader(context),
          CommentArea(),
          CommentInput(screenWidth * 0.8)
        ],
      ),
    );
  }
}
