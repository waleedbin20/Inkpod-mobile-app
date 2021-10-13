import 'dart:convert';
import 'dart:io';

import 'package:app/config/WidgetSpace.dart';
import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/models/Response.dart';
import 'package:app/models/User.dart';
import 'package:app/widgets/BrandButton.dart';
import 'package:app/widgets/CustomTextField.dart';
import 'package:app/widgets/PageHeader.dart';
import 'package:app/widgets/SnackbarMessage.dart';
import 'package:app/widgets/TapAwayWrapper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final titleTextController = TextEditingController();
  final bodyTextController = TextEditingController();
  XFile? imageFile = null;
  String categoryValue = "";

  late Future<List<Topic>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = getCategories();
  }

  @override
  void dispose() {
    super.dispose();
    titleTextController.dispose();
    bodyTextController.dispose();
  }

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageFile = pickedFile;
      });
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  ImagePreview() {
    return FittedBox(
      fit: BoxFit.fill,
      child: Image.file(
        File(imageFile?.path ?? ""),
        fit: BoxFit.fill,
      ),
    );
  }

  Future<List<Topic>> getCategories() async {
    http.Response topicsRes =
        await http.get(Uri.parse("https://api.inkpod.org/v0/topics"));
    if (topicsRes.statusCode == 200) {
      final topics = List.from(jsonDecode(topicsRes.body)['topics']);
      return List.from(topics.map((topic) => Topic.fromJson(topic)));
    }

    return [Topic(imageUrl: "", label: "Could not load", value: "")];
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return TapawayWrapper(
      child: Scaffold(
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                floating: true,
                delegate: SliverHeading(heading: "Add Article"),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomTextField(
                    inputHint: 'Title',
                    textController: titleTextController,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: InkWell(
                  onTap: () => _pickImage(),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: screenHeight / 4,
                    width: screenWidth,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius))),
                    child: imageFile != null
                        ? ImagePreview()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              Text("Tap to add image")
                            ],
                          ),
                  ),
                ),
              ),
              FutureBuilder<List<Topic>>(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(borderRadius)),
                              color: Colors.grey[100]),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: categoryValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            elevation: 0,
                            underline: SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() => categoryValue = newValue!);
                            },
                            items: [
                              DropdownMenuItem<String>(
                                  child: Text("Select"), value: ""),
                              ...?snapshot.data?.map<DropdownMenuItem<String>>(
                                  (Topic topic) {
                                return DropdownMenuItem<String>(
                                  value: topic.value,
                                  child: Text(topic.label),
                                );
                              }).toList()
                            ],
                          ),
                        ),
                      );
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text("Loading categories..."),
                      ),
                    );
                  }),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomTextField(
                    inputHint: 'Body',
                    textController: bodyTextController,
                    isMultiline: true,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BrandButton(
                  buttonText: "Add Article",
                  onTap: () async {
                    final body = bodyTextController.text;
                    final title = titleTextController.text;

                    final res = await uploadArticle(
                        body: body,
                        title: title,
                        category: categoryValue,
                        imagePath: imageFile?.path ?? "");

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackbarMessage(res.message));

                    if (res.success) {
                      bodyTextController.clear();
                      titleTextController.clear();
                      setState(() {
                        imageFile = null;
                        categoryValue = "";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Response> uploadArticle({title, body, imagePath, category}) async {
  if (imagePath == "")
    return Response(success: false, message: "Image is required");

  Future<User> getUserData() => UserPreferences().getUser();

  String id = (await getUserData()).id;

  var request = http.MultipartRequest(
      'POST', Uri.parse("https://api.inkpod.org/v0/article"))
    ..fields['title'] = title
    ..fields['body'] = body
    ..fields['category'] = category
    ..fields['userId'] = id
    ..files.add(await http.MultipartFile.fromPath("image", imagePath));

  var addArticleRes = await request.send();
  if (addArticleRes.statusCode == 200)
    return Response(success: true, message: "Article saved successfully");
  else
    return Response(success: false, message: "Could not upload article");
}

class Topic {
  final String label;
  final String value;
  final String imageUrl;

  Topic({required this.imageUrl, required this.label, required this.value});

  factory Topic.fromJson(Map json) {
    return Topic(
        label: json['title'], value: json['value'], imageUrl: json['imgUrl']);
  }
}
