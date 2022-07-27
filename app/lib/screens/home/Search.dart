import 'dart:convert';

import 'package:app/config/WidgetSpace.dart';
import 'package:app/config/constant.dart';
import 'package:app/models/Response.dart';
import 'package:app/screens/home/AddArticle.dart';
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
  List<Topic>? topics;
  bool isLoading = true;
  String? error;
  Future<void> fetchTopics() async {
    final response =
        await http.get(Uri.parse('${Constants.baseUrl}/v0/topics'));

    if (response.statusCode == 200) {
      final parsedRes = jsonDecode(response.body)['topics'];
      topics = parsedRes.map<Topic>((topic) => Topic.fromJson(topic)).toList();
    } else {
      error = "Something went wrong while fetching articles";
    }
  }

  @override
  void initState() {
    super.initState();
    topics = [];
    // futureTopics = fetchTopics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTopics().then((res) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<Topic> get list {
    if (topics == null || topics!.isEmpty) return [];

    final data = topics!
        .where((element) => element.value
            .toLowerCase()
            .contains(searchTextController.text.toLowerCase()))
        .toList();
    data.sort((a, b) => b.value.compareTo(a.value));
    return data;
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
                      onChanged: (val) {
                        print(val);
                        setState(() {});
                      },
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
            if (list.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      final currentTopic = list[idx];
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 25, top: 15),
                            clipBehavior: Clip.antiAlias,
                            height: 280,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(borderRadius / 2)),
                            ),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder_image.png',
                                image: currentTopic.imageUrl,
                                // height: 250,
                                // width: 120,
                                fit: BoxFit.contain,
                                fadeOutDuration: Duration(milliseconds: 125),
                                fadeInDuration: Duration(milliseconds: 125),
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                currentTopic.value,
                              )),
                        ],
                      );
                    },
                    childCount: list.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                ),
              ),
            if (isLoading) SliverFillRemaining(child: BrandLoader()),
            if (error != null)
              SliverToBoxAdapter(
                child: Center(
                  child: Text('$error'),
                ),
              )
          ],
        )),
      ),
    );
  }
}
