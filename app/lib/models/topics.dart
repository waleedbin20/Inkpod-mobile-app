class Topic {
  final String? title;
  final String? value;
  final String? imgUrl;

  Topic({this.title, this.value, this.imgUrl});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json['title'] != null ? json['title'] : null,
      value: json['value'] != null ? json['value'] : null,
      imgUrl: json['imgUrl'] != null ? json['imgUrl'] : null,
    );
  }

  static List<Topic> fromApi(List<dynamic> resArr) {
    return resArr.map((topic) => Topic.fromJson(topic)).toList();
  }
}
