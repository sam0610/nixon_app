part of nixon_app;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    TranslateHelper()._load();
    _auth.currentUser().then((FirebaseUser user) {
      if (user != null) {
        AuthHelper.setCurrentUser(user);
        new Future.delayed(new Duration(seconds: 5))
            .then((_) => Navigator.of(context).pushReplacementNamed("/home"));
      } else {
        new Future.delayed(new Duration(seconds: 5))
            .then((_) => Navigator.of(context).pushReplacementNamed("/login"));
      }
    });
    print('splash init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.redAccent.shade700,
      body: new Container(
        height: double.infinity,
        width: double.infinity,
        child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new NxLogo(
                color: Colors.white,
              ),
              new SizedBox(
                height: 20.0,
              ),
              new AnimatedCircularProgress(),
            ],
          ),
        ),
      ),
    );
  }
}
