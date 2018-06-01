import 'package:flutter/material.dart';
import 'package:nixon_app/nixon_app.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  /*Future<bool> _checkLogin() async {
    bool result;
    await FirebaseAuth.instance
        .currentUser()
        .then((user) => user != null ? result = true : result = false);
    return result;
  }

  bool _login() {
    _checkLogin().then((bool result) {
      return true;
    }).catchError((onError) {
      return false;
    });
    return false;
  }

*/
  TextTheme buildTextTheme() {
    final textTheme = new TextTheme(
        display1: new TextStyle(color: Colors.black),
        display2: new TextStyle(color: Colors.black),
        display3: new TextStyle(color: Colors.black),
        display4: new TextStyle(color: Colors.black),
        headline: new TextStyle(color: Colors.black),
        title: new TextStyle(color: Colors.black),
        subhead: new TextStyle(color: Colors.black),
        body2: new TextStyle(color: Colors.black),
        body1: new TextStyle(color: Colors.black),
        caption: new TextStyle(color: Colors.black),
        button: new TextStyle(color: Colors.black));
    return textTheme;
  }

  ThemeData buildThemeData() {
    final baseTheme = ThemeData.light();
    return baseTheme.copyWith(
        //textTheme: new TextTheme(),
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
