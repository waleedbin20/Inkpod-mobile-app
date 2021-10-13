import 'dart:convert';

import 'package:app/data/storage/PersistantStorage.dart';
import 'package:app/models/Response.dart';
import 'package:app/models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  String email = "";
  String name = "";
  String userVerified = "";
  String authToken = "";
  String gender = "";

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Response> loginUser({email, password}) async {
    String message;
    bool success = false;
    var user = null;

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
    };

    http.Response loginRes = await http.post(
      Uri.parse("https://api.inkpod.org/v0/auth/login"),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (loginRes.statusCode == 200) {
      success = true;
      final Map<String, dynamic> responseData = json.decode(loginRes.body);

      var userData = responseData['user'];
      var token = responseData['token'];

      User authUser = User.fromJson(userData, token);

      await UserPreferences().saveUser(authUser);

      user = authUser;

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      message = responseData['message'];
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      message = json.decode(loginRes.body)['message'];
    }

    return Response(success: success, message: message, data: user);
  }

  Future<Response> registerUser(
      {email, name, password, confirmPassword}) async {
    String message;
    bool success = false;
    var user = null;

    _registeredInStatus = Status.Registering;
    notifyListeners();

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'name': name,
      'confirmPassword': confirmPassword
    };

    http.Response registerRes = await http.post(
      Uri.parse("https://api.inkpod.org/v0/auth/register"),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (registerRes.statusCode == 200) {
      success = true;
      final Map<String, dynamic> responseData = json.decode(registerRes.body);

      var userData = responseData['user'];
      var token = responseData['token'];

      User authUser = User.fromJson(userData, token);

      await UserPreferences().saveUser(authUser);

      user = authUser;

      _registeredInStatus = Status.Registered;
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      message = responseData['message'];
    } else {
      _registeredInStatus = Status.NotRegistered;
      notifyListeners();
      message = json.decode(registerRes.body)['message'];
    }

    return Response(success: success, message: message, data: user);
  }
}
