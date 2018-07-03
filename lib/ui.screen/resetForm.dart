part of nixon_app;

class ResetForm extends StatefulWidget {
  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  TextEditingController _email = new TextEditingController();

  void showSnackBar(String msg) {}

  void reset() async {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: new Builder(builder: (BuildContext context) {
      return new Padding(
        padding: const EdgeInsets.all(18.0),
        child: new Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Text(TranslateHelper.translate('reset user password')),
              new TextFormField(
                decoration: new InputDecoration(
                    labelText: TranslateHelper.translate('Email')),
                controller: _email,
                keyboardType: TextInputType.text,
              ),
              new SizedBox(
                height: 10.0,
              ),
              new RaisedButton(
                child: new Text(TranslateHelper.translate('confirm')),
                onPressed: () {
                  _auth.sendPasswordResetEmail(email: _email.text).then((_) {
                    FormHelper.showAlertDialog(
                        context: context,
                        title: TranslateHelper.translate("request completed"),
                        message: TranslateHelper
                            .translate("please check your email"));
                    Navigator.of(context).pop();
                  }).catchError((onError) {
                    Scaffold.of(context).showSnackBar(
                          new SnackBar(
                              duration: new Duration(seconds: 1),
                              content: new Text(onError.toString()),
                              backgroundColor: Theme.of(context).primaryColor),
                        );
                  });
                },
              )
            ],
          ),
        ),
      );
    }));
  }
}
