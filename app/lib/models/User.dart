class User {
  final String id;
  final String? email;
  final String? name;
  final String? profilePic;
  final String token;
  final bool? userVeried;
  final String? userType;
  final String? gender;
  final List<dynamic>? articles;
  final List<dynamic>? bookmarked;

  User(
      {this.email,
      this.id = "",
      this.name,
      this.profilePic,
      this.userVeried,
      this.token = "",
      this.userType,
      this.gender,
      this.articles,
      this.bookmarked});

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
        bookmarked: json['bookmarked'] ?? [],
        email: json['email'] ?? null,
        id: json['_id'] ?? "",
        userType: json['userType'] ?? null,
        articles: json['articles'] ?? [],
        name: json['name'] ?? null,
        gender: json['gender'] ?? null,
        profilePic: json['profilePic'] ?? null,
        token: token,
        userVeried: json['userVeried'] ?? null);
  }
}
