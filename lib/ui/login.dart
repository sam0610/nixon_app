part of nixon_app;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: BodyWidget());
  }
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => new _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _passwordEditController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _showLoading = false;

  void showSnackBar(String msg) {
    Scaffold.of(context).showSnackBar(
          new SnackBar(
              duration: new Duration(seconds: 10),
              content: new Text(msg),
              backgroundColor: Theme.of(context).primaryColor),
        );
  }

  Widget _passwordTextField() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
      child: new TextFormField(
        validator: (value) => value.isEmpty ? "password required" : null,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: new InputDecoration(
            hintText: "password",
            icon: new Icon(
              Icons.lock,
              color: Theme.of(context).primaryColor,
            )),
        controller: _passwordEditController,
        maxLines: 1,
      ),
    );
  }

  Widget _subtmitBtn() {
    return new Expanded(
      child: new RaisedButton(
        onPressed: login,
        color: Colors.blue,
        child: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: new Icon(Icons.send)),
              new Text("Login")
            ],
          ),
        ),
      ),
    );
  }

  Widget _clearBtn() {
    return new RaisedButton(
      onPressed: () {
        setState(() {
          _emailEditController.clear();
          _passwordEditController.clear();
        });
      },
      color: Colors.redAccent,
      child: new Container(
        padding: EdgeInsets.all(10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(right: 8.0),
              child: new Icon(Icons.clear),
            ),
            new Text("Clear")
          ],
        ),
      ),
    );
  }

  Widget _buttonBar() {
    return new Center(
      child: new Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _clearBtn(),
            new Padding(padding: EdgeInsets.only(right: 20.0)),
            _subtmitBtn(),
          ],
        ),
      ),
    );
  }

  login() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      _showLoading = true;
      _handleSignIn().then((FirebaseUser user) {
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((e) {
        _showLoading = false;
        showSnackBar("Login Failed:" + e.toString());
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: _emailEditController.text.toLowerCase().trim(),
        password: _passwordEditController.text.trim());
    return user;
  }

  Widget _emailTextField() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
      child: new TextFormField(
        validator: (value) => value.isEmpty ? "email is required" : null,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
            hintText: "login email",
            icon: new Icon(
              Icons.email,
              color: Theme.of(context).primaryColor,
            )),
        controller: _emailEditController,
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: new ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        children: <Widget>[
          new NxLogo(),
          _emailTextField(),
          _passwordTextField(),
          _buttonBar(),
          _showLoading
              ? new CircularProgressIndicator(
                  strokeWidth: 8.0,
                )
              : null,
        ],
      ),
    ));
  }
}

class NxLogo extends StatefulWidget {
  @override
  _NxLogoState createState() => new _NxLogoState();
}

class _NxLogoState extends State<NxLogo> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    final CurvedAnimation curve =
        new CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _animation = new Tween(begin: 0.0, end: 120.0).animate(curve);
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GrowTransition(
        child: new Container(
          child: new Image.asset(
            'asset/nx_logo.png',
            height: _animation.value,
            width: _animation.value,
            color: Colors.red.shade800,
          ),
        ),
        animation: _animation);
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return new Container(
              height: animation.value,
              width: animation.value,
              child: new Opacity(
                opacity: animation.value / 150,
                child: child,
              ),
            );
          },
          child: child),
    );
  }
}
