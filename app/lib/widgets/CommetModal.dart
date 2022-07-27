import 'dart:developer';

import 'package:app/config/WidgetSpace.dart';
import 'package:app/config/constant.dart';
import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/widgets/CustomTextField.dart';
import 'package:app/widgets/EmptyMessage.dart';
import 'package:app/widgets/PageHeader.dart';
import 'package:app/widgets/SmallButton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentModal extends StatefulWidget {
  final postId;
  const CommentModal({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentModalState createState() => _CommentModalState();
}

Widget _commentArea() => Expanded(
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            EmptyMessage(
              message: "No comments yet",
            )
          ],
        ),
      ),
    );

class _CommentModalState extends State<CommentModal> {
  TextEditingController commentController = new TextEditingController();

  String? userId;
  late ValueNotifier<bool> isLoading;
  @override
  void initState() {
    isLoading = ValueNotifier(false);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserPreferences().getUser().then((value) {
        setState(() {
          userId = value.id;
        });
      });
    });
  }

  Future<void> addComment() async {
    try {
      isLoading.value = true;
      var url = "${Constants.baseUrl}/v0/comment";
      var body = {
        "articleId": widget.postId,
        "userId": "$userId",
        "comment": commentController.text
      };
      var response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        setState(() {
          commentController.text = "";
        });
        log("Comment added successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Comment added successfully"),
          ),
        );
      } else {
        log("Error adding comment", error: response.body);
      }
    } catch (e) {
      log("Error adding comment", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Widget _commentHeader(context) => InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [PageHeading("Comments"), Icon(Icons.keyboard_arrow_down)],
        ),
      );

  Widget _commentInput(textFieldWidth) => Row(
        children: [
          Container(
            width: textFieldWidth,
            child: CustomTextField(
              textController: commentController,
              inputHint: "Write a comment...",
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (BuildContext context, bool value, Widget? child) {
              if (value) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              return SquareIconButton(
                icon: Icons.send,
                onClick: () {
                  print(commentController.text);
                  addComment();
                },
              );
            },
          ),
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
          _commentHeader(context),
          _commentArea(),
          _commentInput(screenWidth * 0.8)
        ],
      ),
    );
  }
}
