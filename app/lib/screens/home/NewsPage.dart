import 'dart:convert';

import 'package:app/config/WidgetSpace.dart';
import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/models/Article.dart';
import 'package:app/models/Response.dart';
import 'package:app/models/User.dart';
import 'package:app/widgets/BrandLoader.dart';
import 'package:app/widgets/FullScreenNewsView.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<dynamic> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  Future<Response> fetchArticles() async {
    final response =
        await http.get(Uri.parse('https://api.inkpod.org/v0/article'));

    if (response.statusCode == 200) {
      final parsedRes = Article.fromApi(jsonDecode(response.body)['articles']);
      return Response(message: "", data: parsedRes);
    } else {
      return Response(message: "Something went wrong while fetching articles");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        height: screenHeight - (appbarheight + bottomnavHeight),
        child: FutureBuilder<dynamic>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Article> articles = snapshot.data.data;
              final int dataLength = snapshot.data.data.length;
              return ScrollSnapList(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(0),
                itemBuilder: (BuildContext ctx, int idx) {
                  return FullScreenNewsView(article: articles[idx]);
                },
                itemCount: dataLength,
                itemSize: (screenHeight - (appbarheight + bottomnavHeight)),
                onItemFocus: (idx) {},
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return BrandLoader();
          },
        ));
  }
}

Future<Response> updateLikes({evenType, userId, articleId}) async {
  // if (even == "")
  //   return Response(success: false, message: "Image is required");

  Future<User> getUserData() => UserPreferences().getUser();

  userId = (await getUserData()).id;

  var request = http.MultipartRequest(
      'POST', Uri.parse("https://api.inkpod.org/v0/article"))
    ..fields['id'] = articleId
    ..fields['likes'] = evenType
    ..fields['userId'] = userId;

  var addArticleRes = await request.send();
  if (addArticleRes.statusCode == 200)
    return Response(success: true, message: "Upated Like");
  else
    return Response(success: false, message: "Could not upload article");
}
