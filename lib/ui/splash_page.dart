part of nixon_app;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _auth.onAuthStateChanged.firstWhere((user) => user != null).then((user) {
      AuthHelper.setCurrentUser(user);
      new Future.delayed(new Duration(seconds: 5))
          .then((_) => Navigator.of(context).pushReplacementNamed("/home"));
    });

    _auth.onAuthStateChanged.firstWhere((user) => user == null).then((user) {
      new Future.delayed(new Duration(seconds: 5))
          .then((_) => Navigator.of(context).pushReplacementNamed("/login"));
    });
    super.initState();
  }

  login() {
    new Future.delayed(new Duration(seconds: 5))
        .then((_) => Navigator.of(context).pushReplacementNamed("/login"));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.redAccent.shade700,
        body: new Center(child: new AnimatedCircularProgress()));
  }
}
