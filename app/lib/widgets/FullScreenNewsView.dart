import 'package:app/config/WidgetSpace.dart';
import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/models/Article.dart';
import 'package:app/models/Response.dart';
import 'package:app/models/User.dart';
import 'package:app/screens/home/NewsPage.dart';
import 'package:app/widgets/CommetModal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class FullScreenNewsView extends StatefulWidget {
  final Article article;
  final bool fullHeight;
  const FullScreenNewsView(
      {Key? key, required this.article, this.fullHeight = false})
      : super(key: key);

  @override
  _FullScreenNewsViewState createState() => _FullScreenNewsViewState();
}

class _FullScreenNewsViewState extends State<FullScreenNewsView> {
  bool isLiked = false;
  bool isDisliked = false;

  likePost() => setState(() => isLiked = !isLiked);
  dislikePost() => setState(() => isDisliked = !isDisliked);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight -
          (widget.fullHeight ? 10 : (appbarheight + bottomnavHeight)),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: screenWidth,
            margin: EdgeInsets.only(top: widget.fullHeight ? 20 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            child: FittedBox(
              fit: BoxFit.fill,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder_image.png',
                image: widget.article.coverImg,
                height: screenHeight / 4,
                width: screenWidth,
                fit: BoxFit.cover,
                fadeOutDuration: Duration(milliseconds: 125),
                fadeInDuration: Duration(milliseconds: 125),
              ),
            ),
          ),
          SizedBox(height: 20),
          Flexible(
              flex: 3,
              child: Container(
                child: Text(
                  widget.article.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 24, height: 1.2, letterSpacing: -0.2),
                ),
              )),
          SizedBox(height: 20),
          Expanded(
              flex: 5,
              child: Scrollbar(
                child: SingleChildScrollView(
                    child: Text(
                  widget.article.body,
                  style: TextStyle(fontSize: 16),
                )),
              )),
          SizedBox(height: 3),
          Row(
            children: [
              Text("Courtesy of"),
              TextButton(
                onPressed: () {},
                child: Text(widget.article.owner.name),
              )
            ],
          ),
          SizedBox(height: 20),
          ActionPanel(widget.article, context,
              toggleLike: likePost,
              toggleDislike: dislikePost,
              isLiked: isLiked,
              isDisliked: isDisliked),
        ],
      ),
    );
  }
}

Widget ActionPanel(Article article, BuildContext ctx,
    {required Function toggleLike,
    required Function toggleDislike,
    required bool isLiked,
    required bool isDisliked}) {
  final likes = article.likes.length;

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            IconButton(
                onPressed: () {
                  toggleLike();
                  //updateLikes(evenType: article, articleId: article.id);
                },
                icon: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined)),
            Text((isLiked ? likes + 1 : likes).toString())
          ],
        ),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  toggleDislike();
                  updateLikes(articleId: article.id, evenType: '');
                },
                icon: Icon(isDisliked
                    ? Icons.thumb_down
                    : Icons.thumb_down_alt_outlined)),
            Text("Dislike")
          ],
        ),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                      isScrollControlled: true,
                      builder: (BuildContext ctx) =>
                          CommentModal(postId: article.id),
                      context: ctx);
                },
                icon: Icon(Icons.comment)),
            Text("Comment")
          ],
        ),
        Column(
          children: [
            IconButton(
                onPressed: () => onShareArticle(ctx, article.id),
                icon: Icon(Icons.share)),
            Text("Share")
          ],
        ),
      ],
    ),
  );
}

onShareArticle(BuildContext ctx, String id) async {
  await Share.share("https://www.inkpod.org/news/$id");
  return;
}

Future<Response> updateLikes(
    {required String evenType, userId, articleId}) async {
  // if (even == "")
  //   return Response(success: false, message: "Image is required");

  Future<User> getUserData() => UserPreferences().getUser();

  userId = (await getUserData()).id;

  var request = http.MultipartRequest(
      'PUT', Uri.parse("https://api.inkpod.org/v0/article"))
    ..fields['id'] = articleId
    ..fields['likes'] = evenType
    ..fields['userId'] = userId;

  var addArticleRes = await request.send();
  if (addArticleRes.statusCode == 200)
    return Response(success: true, message: "Upated Like");
  else
    return Response(success: false, message: "Could not upload article");
}
