import 'dart:convert';

import 'package:app/config/WidgetSpace.dart';
import 'package:app/config/constant.dart';
import 'package:app/models/Article.dart';
import 'package:app/utilWidgets/PageSlide.dart';
import 'package:app/widgets/BrandLoader.dart';
import 'package:app/widgets/OverNewsReader.dart';
import 'package:app/widgets/PageHeader.dart';
import 'package:app/models/Response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrendingPage extends StatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  late Future<dynamic> futureArticles;

  Future<Response> fetchArticles() async {
    final response =
        await http.get(Uri.parse('${Constants.baseUrl}/v0/article'));

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
    _tabController = TabController(length: 2, vsync: this);
    futureArticles = fetchArticles();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget TrendingList(List<Article> articles, double screenHeight) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int idx) {
        Article currentArticle = articles[idx];

        return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  Slide(
                      page: OverlayNewsReader(
                    articles: articles,
                    toPosition: idx * screenHeight,
                  )));
            },
            minLeadingWidth: 100,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            title: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(currentArticle.title),
            ),
            leading: Container(
              clipBehavior: Clip.antiAlias,
              height: 80,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  )
                ],
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius / 2.5)),
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
            ));
      }, childCount: articles.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: SliverHeading(heading: "Trending"),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.grey[100]),
                  child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          borderRadius,
                        ),
                        color: Colors.red,
                      ),
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: Text("Global"),
                          ),
                        ),
                        Tab(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Text("National"),
                        )),
                      ]),
                ),
              ),
            ),
            FutureBuilder<dynamic>(
              future: futureArticles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Article> articles = snapshot.data.data;
                  return TrendingList(articles, screenHeight);
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(child: Text('${snapshot.error}')));
                }
                return SliverFillRemaining(child: BrandLoader());
              },
            )
          ],
        ),
      ),
    );
  }
}
