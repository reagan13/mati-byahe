import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../core/constant/app_texts.dart';

class NavigationScreens {
  static List<Widget> getScreens(String email, String role) {
    bool isDriver = role.toLowerCase() == 'driver';

    if (isDriver) {
      return [
        HomeScreen(email: email, role: role),
        _placeholder(AppTexts.navEarnings),
        _placeholder(AppTexts.navVehicle),
        _placeholder(AppTexts.navProfile),
      ];
    }

    return [
      HomeScreen(email: email, role: role),
      _placeholder(AppTexts.navHistory),
      _placeholder("Scanner"),
      _placeholder(AppTexts.navReport),
      _placeholder(AppTexts.navProfile),
    ];
  }

  static Widget _placeholder(String text) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text(text)),
    );
  }
}
