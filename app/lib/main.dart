import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/models/User.dart';
import 'package:app/data/AuthProvider.dart';
import 'package:app/data/UserProvider.dart';
import 'package:app/screens/auth/AuthScreen.dart';
import 'package:app/screens/home/Homepage.dart';
import 'package:app/widgets/BrandLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Inkpod',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black)),
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Colors.white,
            bottomAppBarTheme:
                BottomAppBarTheme(color: Colors.white, elevation: 0)),
        home: FutureBuilder<User>(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return BrandLoader();
              default:
                if (snapshot.hasData && snapshot.data?.token != "")
                  return HomePage();
                else
                  return AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
