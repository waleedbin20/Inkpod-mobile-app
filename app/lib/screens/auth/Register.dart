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

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = new TextEditingController();
  final nameTextCotroller = new TextEditingController();
  final passwordTextCotroller = new TextEditingController();
  final confirmPasswordTextCotroller = new TextEditingController();

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
                  textController: nameTextCotroller, inputHint: "Name"),
              CustomTextField(
                  textController: passwordTextCotroller,
                  inputHint: "Password",
                  shoulObscureText: true),
              CustomTextField(
                  textController: confirmPasswordTextCotroller,
                  inputHint: "Confirm Password",
                  shoulObscureText: true),
              BrandButton(
                buttonText: 'Sign Up',
                onTap: () async {
                  final String email = emailTextController.text;
                  final String name = nameTextCotroller.text;
                  final String password = passwordTextCotroller.text;
                  final String confirmPassword =
                      confirmPasswordTextCotroller.text;

                  setState(() => isLoading = true);
                  final response = await auth.registerUser(
                      email: email,
                      name: name,
                      password: password,
                      confirmPassword: confirmPassword);

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
