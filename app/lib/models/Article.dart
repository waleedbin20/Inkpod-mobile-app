import 'package:app/models/Comment.dart';
import 'package:app/models/Owner.dart';



class Article {
  final String id;
  final String title;
  final String body;
  final String coverImg;
  final String? category;
  final DateTime createdOn;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  final List<Comment> comments;
  final String? topic;
  final Owner owner;

  Article(
      {required this.id,
      required this.title,
      required this.body,
      required this.coverImg,
      this.category,
      required this.createdOn,
      required this.likes,
      required this.dislikes,
      required this.comments,
      this.topic,
      required this.owner});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        id: json['_id'],
        title: json['title'],
        body: json['body'],
        coverImg: json['coverImg'],
        category: json['category'],
        createdOn: DateTime.parse(json['createdOn']),
        likes: json['likes'].toList(),
        dislikes: json['dislikes'].toList(),
        comments: Comment.fromApi(json['comments']),
        topic: json['topic'],
        owner: Owner.fromJson(json['owner']));
  }
  

  static List<Article> fromApi(List<dynamic> resArr) {
    return resArr.map((article) => Article.fromJson(article)).toList();
  }
}
