class Comment {
  final String comment;
  final DateTime createdOn;
  final String article;
  final String owner;

  Comment(
      {required this.comment,
      required this.createdOn,
      required this.article,
      required this.owner});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        comment: json['comment'],
        createdOn: json['createdOn'],
        article: json['article'],
        owner: json['owner']);
  }

  static List<Comment> fromApi(List<dynamic> jsonComments) {
    // return jsonComments.map((comment) => Comment.fromJson(comment)).toList();
    return [];
  }
}
