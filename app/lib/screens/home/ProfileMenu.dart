import 'package:app/data/UserProvider.dart';
import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/models/User.dart';
import 'package:app/screens/BecomeModerator.dart';
import 'package:app/screens/MyPosts.dart';
import 'package:app/screens/auth/AuthScreen.dart';
import 'package:app/utilWidgets/PageSlide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.description),
                title: Text("My Posts"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => Navigator.push(context, Slide(page: MyPosts())),
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text("Become a moderator"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () =>
                    Navigator.push(context, Slide(page: BecomeModerator())),
              ),
              ListTile(
                leading: Icon(Icons.policy),
                title: Text("Privacy Policy"),
                onTap: () => launch("https://www.inkpod.org/privacy-policy"),
              ),
              ListTile(
                leading: Icon(Icons.find_in_page),
                title: Text("Terms & Condition"),
                onTap: () => launch("https://www.inkpod.org/terms"),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Contact"),
                onTap: () => launch("https://www.inkpod.org/contact"),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Sign out"),
                onTap: () {
                  UserPreferences().removeUser();
                  Provider.of<UserProvider>(context, listen: false)
                      .setUser(User());
                  Navigator.push(context, Slide(page: AuthScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
