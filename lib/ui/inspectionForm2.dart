import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Helper/formHelper.dart';
import '../Models/Inspection.dart';
import '../Models/InspectionRepository.dart';

class InspectionForm extends StatefulWidget {
  InspectionForm({this.form});
  final Inspection form;
  @override
  _InspectionFormState createState() => new _InspectionFormState();
}

Inspection myform;

class _InspectionFormState extends State<InspectionForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  InspectionRepos repos;

  TextEditingController _formDateController = new TextEditingController();
  TextEditingController _staffNameController = new TextEditingController();
  TextEditingController _leaveTimeController = new TextEditingController();
  TextEditingController _arrivedTimeController = new TextEditingController();
  TextEditingController _situationRemarkController =
      new TextEditingController();
  TextEditingController _guestsProportionController =
      new TextEditingController();
  TextEditingController _foundLocationController = new TextEditingController();
  TextEditingController _postNameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    myform = widget.form;
    //_formDateController.text =
    //    FormHelper.datetoString(myform.inspectionDate ?? new DateTime.now());
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) repos = new InspectionRepos.forUser(user: user);
    });
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
                new DateTextField(
                  labelText: '日期',
                  initialValue: FormHelper.datetoString(
                      myform.inspectionDate ?? new DateTime.now()),
                  controller: _formDateController,
                  onSave: (value) =>
                      myform.inspectionDate = FormHelper.strToDate(value),
                ),
                MyFormTextField(
                    labelText: '員工姓名',
                    initialValue: myform.staffName,
                    controller: _staffNameController,
                    onSave: (value) => myform.staffName = value),
                MyFormTextField(
                    labelText: '位置',
                    initialValue: myform.foundLocation,
                    controller: _foundLocationController,
                    onSave: (value) => myform.foundLocation = value),
                MyFormTextField(
                    labelText: '崗位',
                    initialValue: myform.postName,
                    controller: _postNameController,
                    onSave: (value) => myform.postName = value),
                MyFormTextField(
                    labelText: '處境摘要',
                    initialValue: myform.situationRemark,
                    controller: _situationRemarkController,
                    onSave: (value) => myform.situationRemark = value),
                TimeTextField(
                    labelText: '到達時間',
                    initialValue: myform.arrivedTime,
                    controller: _arrivedTimeController,
                    onSave: (value) =>
                        myform.arrivedTime = FormHelper.timetoString(value)),
                TimeTextField(
                    labelText: '離開時間',
                    initialValue: myform.leaveTime,
                    controller: _leaveTimeController,
                    onSave: (value) =>
                        myform.leaveTime = FormHelper.timetoString(value)),
                MyFormTextField(
                    labelText: '顧客比例',
                    initialValue: myform.guestsProportion,
                    controller: _guestsProportionController,
                    onSave: (value) => myform.guestsProportion = value),
              ],
            ),
          ),
        ));
  }
}

var _labelStyle = new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
var _textStyle = new TextStyle(fontSize: 25.0, color: Colors.black);

class DateTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  final Function onSave;
  DateTextField(
      {this.controller, this.initialValue, this.labelText, this.onSave});

  @override
  _DateTextFieldState createState() => new _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  Widget build(BuildContext context) {
    return new Row(children: [
      new Expanded(
        child: new TextFormField(
          style: _textStyle,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: _labelStyle,
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) =>
              value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
          onSaved: widget.onSave,
        ),
      ),
      new IconButton(
        icon: new Icon(Icons.arrow_drop_down),
        onPressed: () => selectDate(context),
      )
    ]);
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await FormHelper.selectDateDialog(ctx: context);
    if (picked != null) {
      setState(
        () {
          widget.controller.text = FormHelper.datetoString(picked);
        },
      );
    }
  }
}

class TimeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  final Function onSave;
  TimeTextField(
      {this.controller, this.initialValue, this.labelText, this.onSave});

  @override
  _TimeTextFieldState createState() => new _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  @override
  Widget build(BuildContext context) {
    return new Row(children: [
      new Expanded(
        child: new TextFormField(
          style: _textStyle,
          controller: widget.controller,
          decoration: InputDecoration(
            labelStyle: _labelStyle,
            labelText: widget.labelText,
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) =>
              value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
          onSaved: widget.onSave,
        ),
      ),
      new IconButton(
          icon: new Icon(Icons.arrow_drop_down),
          onPressed: () => selectTime(context,
              initialTime: FormHelper.strToTime(widget.controller.text)))
    ]);
  }

  selectTime(BuildContext context, {TimeOfDay initialTime}) async {
    final TimeOfDay picked = await FormHelper.selectTimeDialog(
        ctx: context, initialTime: initialTime);
    if (picked != null) {
      setState(
        () {
          widget.controller.text = FormHelper.timetoString(picked);
        },
      );
    }
  }
}

class MyFormTextField extends StatefulWidget {
  MyFormTextField(
      {this.labelText, this.initialValue, this.onSave, this.controller});
  final String labelText;
  final TextEditingController controller;
  final Function onSave;
  final String initialValue;

  @override
  _MyFormTextFieldState createState() => new _MyFormTextFieldState();
}

class _MyFormTextFieldState extends State<MyFormTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: _labelStyle,
      ),
      style: _textStyle,
      controller: widget.controller,
      validator: (value) =>
          value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
      onSaved: widget.onSave,
    );
  }
}
