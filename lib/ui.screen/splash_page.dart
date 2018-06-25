part of nixon_app;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  initAnimation() {
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final CurvedAnimation _curve =
        new CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _animation = new Tween(begin: 20.0, end: 80.0).animate(_curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
        _controller.addListener(() {
          if (_controller.value < 0.6) _controller.forward();
        });
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initAnimation();
    _auth.currentUser().then((FirebaseUser user) async {
      if (user != null) {
        AuthHelper.setCurrentUser(user);
        await TranslateHelper()._load();
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
      backgroundColor: Colors.white,
      body: new Container(
        height: double.infinity,
        width: double.infinity,
        child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new GrowTransition(
                  child: new Container(
                    child: new Image.asset(
                      'assets/nx_logo.png',
                      color: Colors.red.shade800,
                    ),
                  ),
                  animation: _animation)
            ],
          ),
        ),
      ),
    );
  }
}
