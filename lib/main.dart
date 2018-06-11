import 'package:flutter/material.dart';
import 'package:nixon_app/nixon_app.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  TextTheme buildTextTheme() {
    final baseTheme = ThemeData.light();
    final textTheme = baseTheme.textTheme
        .copyWith(
            body1: new TextStyle(fontSize: 14.0),
            body2: new TextStyle(fontSize: 18.0),
            title: new TextStyle(fontSize: 20.0),
            subhead: new TextStyle(fontSize: 18.0))
        .apply(displayColor: kPrimaryColor, bodyColor: Colors.black87);
    /*subhead: new TextStyle(color: Colors.grey.shade900), //listtile subtitle
      caption: new TextStyle(color: Colors.grey.shade900), //listtile title
      body1: new TextStyle(color: Colors.red), //textbox text
      body2: new TextStyle(color: Colors.blue), //drawer text // */

    return textTheme;
  }

  ThemeData buildThemeData() {
    final baseTheme = ThemeData.light();
    return baseTheme.copyWith(
        textTheme: buildTextTheme(),
        primaryColor: kPrimaryColor,
        primaryColorDark: kPrimaryDark,
        primaryColorLight: kPrimaryLight,
        accentColor: kSecondaryColor,
        bottomAppBarColor: kSecondaryDark,
        buttonColor: kSecondaryLight,
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: kSecondaryColor,
          primaryColorDark: kSecondaryDark,
          primaryColorLight: kSecondaryLight,
          valueIndicatorTextStyle: TextStyle(color: Colors.black),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return new AnimatedRoute(
              builder: (_) => new SplashPage(),
              settings: settings,
            );
          case '/home':
            return new AnimatedRoute(
              builder: (_) => new HomePage(),
              settings: settings,
            );
          case '/login':
            return new AnimatedRoute(
              builder: (_) => new LoginPage(),
              settings: settings,
            );
        }
        assert(false);
      },
      theme: buildThemeData(),
    );
  }
}
