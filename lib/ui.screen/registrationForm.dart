part of nixon_app;

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  TextEditingController _displayname = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  void register() async {}

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
                new Text('Registration only work with nixon email'),
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
                      labelText: TranslateHelper.translate('Password')),
                  controller: _password,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new RaisedButton(
                  child: new Text(TranslateHelper.translate('register')),
                  onPressed: _email.text.contains('nixon.com.hk')
                      ? () {
                          AuthHelper
                              .registerUser(
                                  email: _email.text.trim(),
                                  password: _password.text.trim(),
                                  name: _displayname.text.trim())
                              .then((successfull) {
                            if (successfull == true) {
                              FirebaseAuth.instance.signOut();
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                    duration: new Duration(seconds: 1),
                                    content: new Text(
                                        'Verification email sent to your mailbox'),
                                    backgroundColor: Colors.blue,
                                  ));
                              Navigator.of(context).pop();
                            }
                          }).catchError((onError) {
                            Scaffold.of(context).showSnackBar(new SnackBar(
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
