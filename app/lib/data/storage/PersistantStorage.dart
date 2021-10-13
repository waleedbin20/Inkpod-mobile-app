import 'package:app/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", user.name ?? "");
    await prefs.setString("id", user.id);
    await prefs.setString("email", user.email ?? "");
    await prefs.setString("profilePic", user.profilePic ?? "");
    await prefs.setString("userType", user.userType ?? "");
    await prefs.setString("token", user.token);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = prefs.getString("name");
    String id = prefs.getString("id") ?? "";
    String? email = prefs.getString("email");
    String? userType = prefs.getString("userType");
    String? profilePic = prefs.getString("profilePic");
    String token = prefs.getString("token") ?? "";

    return User(
        name: name,
        id: id,
        email: email,
        userType: userType,
        profilePic: profilePic,
        token: token);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("profilePic");
    prefs.remove("userType");
    prefs.remove("token");
  }

  Future<String?> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }
}
