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
  ThemeData buildThemeData() {
    final baseTheme = ThemeData.light();
    return baseTheme.copyWith(
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
