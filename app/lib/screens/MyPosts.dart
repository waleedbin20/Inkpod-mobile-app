import 'dart:convert';

import 'package:app/config/WidgetSpace.dart';
import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/models/Article.dart';
import 'package:app/models/User.dart';
import 'package:app/utilWidgets/PageSlide.dart';
import 'package:app/widgets/BrandLoader.dart';
import 'package:app/widgets/EmptyMessage.dart';
import 'package:app/widgets/OverNewsReader.dart';
import 'package:app/widgets/PageHeader.dart';
import 'package:app/models/Response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> with SingleTickerProviderStateMixin {
  late Future<dynamic> futureArticles;

  Future<User> getUserData() => UserPreferences().getUser();

  Future<Response> fetchArticles() async {
    String id = (await getUserData()).id;

    final response = await http
        .get(Uri.parse('https://api.inkpod.org/v0/user/articles?userId=${id}'));

    if (response.statusCode == 200) {
      final parsedRes = Article.fromApi(jsonDecode(response.body)['articles']);
      return Response(message: "", data: parsedRes);
    } else {
      return Response(message: "Something went wrong while fetching articles");
    }
  }

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget ArticleListTileView(List<Article> articles, double screenHeight) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int idx) {
        Article currentArticle = articles[idx];
        return ListTile(
          onTap: () => Navigator.push(
              context,
              Slide(
                  page: OverlayNewsReader(
                articles: articles,
                toPosition: idx * screenHeight,
              ))),
          minLeadingWidth: 120,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          title: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(currentArticle.title),
          ),
          leading: Container(
            clipBehavior: Clip.antiAlias,
            height: 80,
            width: 120,
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
                image: currentArticle.coverImg,
                height: 80,
                width: 120,
                fit: BoxFit.cover,
                fadeOutDuration: Duration(milliseconds: 125),
                fadeInDuration: Duration(milliseconds: 125),
              ),
            ),
          ),
        );
      }, childCount: articles.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: SliverHeading(heading: "My Posts"),
            ),
            FutureBuilder<dynamic>(
              future: futureArticles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Article> articles = snapshot.data.data;
                  if (articles.length == 0)
                    return EmptyMessage(
                      message: "You have no posts",
                    );
                  return ArticleListTileView(articles, screenHeight);
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(child: Text('${snapshot.error}')));
                }
                return SliverFillRemaining(child: BrandLoader());
              },
            ),
          ],
        ),
      ),
    );
  }
}
