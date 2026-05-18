import 'package:flutter/material.dart';

enum UserRole { traveller, guide, none }

class UserProvider extends ChangeNotifier {
  UserRole _role = UserRole.none;

  UserRole get role => _role;

  bool get isTraveller => _role == UserRole.traveller;
  bool get isGuide => _role == UserRole.guide;
  bool get isLoggedIn => _role != UserRole.none;

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  void logout() {
    _role = UserRole.none;
    notifyListeners();
  }
}