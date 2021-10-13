import 'dart:convert';

import 'package:app/config/WidgetSpace.dart';
import 'package:app/models/Response.dart';
import 'package:app/widgets/BrandLoader.dart';
import 'package:app/widgets/CustomTextField.dart';
import 'package:app/widgets/PageHeader.dart';
import 'package:app/widgets/SmallButton.dart';
import 'package:app/widgets/TapAwayWrapper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchTextController = TextEditingController();

  late Future<dynamic> futureTopics;

  Future<Response> fetchTopics() async {
    final response =
        await http.get(Uri.parse('https://api.inkpod.org/v0/topics'));

    if (response.statusCode == 200) {
      final parsedRes = jsonDecode(response.body)['topics'];
      return Response(message: "", data: parsedRes);
    } else {
      return Response(message: "Something went wrong while fetching articles");
    }
  }

  @override
  void initState() {
    super.initState();
    futureTopics = fetchTopics();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return TapawayWrapper(
      child: Scaffold(
        body: Scrollbar(
            child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: SliverHeading(heading: "Search"),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: screenWidth * 0.8,
                    child: CustomTextField(
                      inputHint: 'Search Inkpod',
                      textController: searchTextController,
                    ),
                  ),
                  SquareIconButton(
                    icon: Icons.search,
                    onClick: () {
                      print(searchTextController.text);
                    },
                  )
                ],
              ),
            ),
            FutureBuilder<dynamic>(
              future: futureTopics,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final topics = snapshot.data.data;
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, idx) {
                          final currentTopic = topics[idx];
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 25, top: 15),
                                clipBehavior: Clip.antiAlias,
                                height: 280,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(borderRadius / 2)),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder_image.png',
                                    image: currentTopic['imgUrl'],
                                    // height: 250,
                                    // width: 120,
                                    fit: BoxFit.contain,
                                    fadeOutDuration:
                                        Duration(milliseconds: 125),
                                    fadeInDuration: Duration(milliseconds: 125),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.bottomCenter,
                                child: Text(currentTopic['title']),
                              )
                            ],
                          );
                        },
                        childCount: topics.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(child: Text('${snapshot.error}')));
                }
                return SliverFillRemaining(child: BrandLoader());
              },
            )
          ],
        )),
      ),
    );
  }
}
