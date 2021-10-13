import 'package:app/screens/auth/Login.dart';
import 'package:app/screens/auth/Register.dart';
import 'package:app/widgets/TapAwayWrapper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: TapawayWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset(
                    "assets/logo.png",
                    width: screenWidth * 0.4,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLogin
                        ? "Don't have an account? "
                        : "Already have an account?"),
                    TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(isLogin ? "Sign Up" : "Sign In")),
                  ],
                ),
                isLogin ? LoginPage() : RegisterPage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("By Signing in you agree to"),
                    TextButton(
                        onPressed: () => launch("https://www.inkpod.org/terms"),
                        child: Text("Terms & Condition"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
