import 'dart:io';

import 'package:app/data/AuthProvider.dart';
import 'package:app/data/UserProvider.dart';
import 'package:app/screens/home/Homepage.dart';
import 'package:app/utilWidgets/PageSlide.dart';
import 'package:app/widgets/BrandButton.dart';
import 'package:app/widgets/BrandLoader.dart';
import 'package:app/widgets/CustomTextField.dart';
import 'package:app/widgets/SnackbarMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = new TextEditingController();
  final passwordTextCotroller = new TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                  textController: emailTextController, inputHint: "Email"),
              CustomTextField(
                  textController: passwordTextCotroller,
                  inputHint: "Password",
                  shoulObscureText: true),
              BrandButton(
                buttonText: 'Sign In',
                onTap: () async {
                  final String email = emailTextController.text;
                  final String password = passwordTextCotroller.text;
                  setState(() => isLoading = true);
                  final response =
                      await auth.loginUser(email: email, password: password);
                  setState(() => isLoading = false);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackbarMessage(response.message));
                  if (!response.success) return;
                  Provider.of<UserProvider>(context, listen: false)
                      .setUser(response.data);
                  Navigator.pushReplacement(context, Slide(page: HomePage()));
                },
              )
            ],
          ),
        ),
        isLoading
            ? Container(
                child: BrandLoader(),
              )
            : SizedBox(),
      ],
    );
  }
}
