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
            new Text("clear")
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

  void _setLoading(bool bool) {
    setState(() {
      _showLoading = bool;
    });
  }

  login() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true;
      });
    } else {
      _setLoading(true);
      AuthHelper
          .loginUser(
              email: _emailEditController.text.trim(),
              password: _passwordEditController.text.trim())
          .then((FirebaseUser user) {
        AuthHelper.setCurrentUser(user).then((_) {
          Navigator.of(context).pushReplacementNamed('/home');
        });
      }).catchError((e) {
        _setLoading(false);
        showSnackBar("Login Failed:" + e.toString());
      });
    }
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
          new NxLogo(
            color: Colors.red,
            repeat: false,
          ),
          new SizedBox(
            height: 30.0,
          ),
          _emailTextField(),
          _passwordTextField(),
          _buttonBar(),
          new Container(
              height: 40.0,
              child: _showLoading
                  ? new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[new AnimatedCircularProgress()])
                  : new Text("")),
        ],
      ),
    ));
  }
}
