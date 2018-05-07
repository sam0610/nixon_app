import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Helper/formHelper.dart';
import '../Models/Inspection.dart';
import '../Models/InspectionRepository.dart';

class InspectionForm2 extends StatefulWidget {
  InspectionForm2({this.form});
  final Inspection form;
  @override
  _InspectionForm2State createState() => new _InspectionForm2State();
}

class _InspectionForm2State extends State<InspectionForm2> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  InspectionRepos repos;
  Inspection myform;

  TextEditingController _formDateController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    myform = widget.form;
    _formDateController.text = FormHelper.datetoString(myform.inspectionDate);
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) repos = new InspectionRepos.forUser(user: user);
    });
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await FormHelper.selectDateDialog(ctx: context);
    if (picked != null) {
      setState(
        () {
          _formDateController.text = FormHelper.datetoString(picked);
        },
      );
    }
  }

  void _save() {
    print('save');
    print(myform);
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (myform.id == null) {
        _addRecord();
      } else {
        _updateRecord();
      }
    }
  }

  void _addRecord() {
    repos.addInspection(myform).then((bool result) {
      Navigator.pop(context);
    }).catchError((onError) => FormHelper.showAlertDialog(
        context, "Error on Save", onError.toString()));
  }

  void _updateRecord() {
    repos.updateInspection(myform).then((bool result) {
      Navigator.pop(context);
    }).catchError((onError) => FormHelper.showAlertDialog(
        context, "Error on Save", onError.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Form2"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.save),
              color: Colors.red,
              onPressed: _save,
            ),
          ],
        ),
        body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key: _formKey,
            autovalidate: false,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        controller: _formDateController,
                        decoration: const InputDecoration(
                          icon: const Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          labelText: "Date",
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) =>
                            value.isEmpty ? 'Date can\'t be empty' : null,
                        onSaved: (value) =>
                            myform.inspectionDate = FormHelper.strToDate(value),
                      ),
                    ),
                    new FlatButton(
                      child: new Icon(Icons.arrow_drop_down),
                      color: Colors.red,
                      onPressed: () => selectDate(context),
                    )
                  ],
                ),
                new TextFormField(
                  decoration: const InputDecoration(labelText: 'Staff Name'),
                  initialValue: myform.staffName ?? "",
                  validator: (value) =>
                      value.isEmpty ? 'Staff can\'t be empty' : null,
                  onSaved: (value) => myform.staffName = value,
                )
              ],
            ),
          ),
        ));
  }
}
