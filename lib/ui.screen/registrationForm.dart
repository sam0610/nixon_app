part of nixon_app;

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  TextEditingController _displayname = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _isObscure = true;

  showPassword() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Builder(builder: (BuildContext context) {
        return new Padding(
          padding: const EdgeInsets.all(18.0),
          child: new Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Text(TranslateHelper.translate('Registration'),
                    style: Theme.of(context).textTheme.title),
                new TextFormField(
                  decoration: new InputDecoration(
                      labelText: TranslateHelper.translate('display Name')),
                  controller: _displayname,
                  keyboardType: TextInputType.text,
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                      labelText: TranslateHelper.translate('Email')),
                  controller: _email,
                  keyboardType: TextInputType.text,
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: TranslateHelper.translate('Password'),
                    suffixIcon: new IconButton(
                      icon: new Icon(Icons.remove_red_eye),
                      color: _isObscure ? Colors.grey : Colors.black,
                      onPressed: () => showPassword(),
                    ),
                  ),
                  controller: _password,
                  obscureText: _isObscure,
                  keyboardType: TextInputType.text,
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new RaisedButton(
                  child: new Text(TranslateHelper.translate('register')),
                  onPressed: _email.text.contains('nixon.com.hk')
                      ? () {
                          !_email.text.contains('nixon.com.hk')
                              ? Scaffold.of(context).showSnackBar(new SnackBar(
                                    duration: new Duration(seconds: 1),
                                    content:
                                        new Text('only nixon.com.hk email'),
                                    backgroundColor: Colors.blue,
                                  ))
                              : AuthHelper
                                  .registerUser(
                                      email: _email.text.trim(),
                                      password: _password.text.trim(),
                                      name: _displayname.text.trim())
                                  .then((successfull) {
                                  if (successfull == true) {
                                    FormHelper.showAlertDialog(
                                        context: context,
                                        title: TranslateHelper
                                            .translate("registration complete"),
                                        message: TranslateHelper.translate(
                                            "please check your email"));
                                    Navigator.of(context).pop();
                                  }
                                }).catchError((onError) {
                                  FirebaseAuth.instance.signOut();
                                  Scaffold
                                      .of(context)
                                      .showSnackBar(new SnackBar(
                                        duration: new Duration(seconds: 1),
                                        content: new Text(onError.toString()),
                                        backgroundColor: Colors.red,
                                      ));
                                });
                        }
                      : null,
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
