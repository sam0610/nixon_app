import 'package:flutter/material.dart';

import '../Helper/formHelper.dart';
import '../Models/Inspection.dart';
import 'inspectionList.dart';

TextEditingController _formDateController = new TextEditingController();
DateTime _formDate;
TextEditingController _staffNameController = new TextEditingController();

class InspectionForm extends StatefulWidget {
  InspectionForm([this.inspection]);
  final Inspection inspection;
  @override
  _InspectionFormState createState() => new _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  bool isnewRecord = false;

  @override
  void initState() {
    super.initState();
    if (widget.inspection == null) isnewRecord = true;
    setState(() {
      if (isnewRecord) {
        _formDate = DateTime.now();
        _formDateController.text = FormHelper.formatDate(DateTime.now());
      } else {
        _formDate = widget.inspection.inspectionDate;
        _formDateController.text =
            FormHelper.formatDate(widget.inspection.inspectionDate);
        _staffNameController.text = widget.inspection.staffName;
      }
    });
  }

  void _save() {
    if (isnewRecord) {
      Inspection inspection = new Inspection(
          inspectionDate: _formDate, staffName: _staffNameController.text);
      inspectionRepos.addInspection(inspection).then((bool result) {
        Navigator.pop(context);
      }).catchError((onError) => FormHelper.showAlertDialog(
          context, "Error on Save", onError.toString()));
    } else {
      Inspection inspection = new Inspection(
          inspectionDate: _formDate,
          staffName: _staffNameController.text,
          id: widget.inspection.id,
          userid: widget.inspection.userid);
      inspectionRepos.updateInspection(inspection).then((bool result) {
        Navigator.pop(context);
      }).catchError((onError) => FormHelper.showAlertDialog(
          context, "Error on Save", onError.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("inspectionForm"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: InsFormBody(),
    );
  }
}

class InsFormBody extends StatefulWidget {
  @override
  _InsFormBodyState createState() => new _InsFormBodyState();
}

class _InsFormBodyState extends State<InsFormBody> {
  selectDate(BuildContext context) async {
    final DateTime picked = await FormHelper.selectDateDialog(ctx: context);
    if (picked != null && picked != _formDate) {
      setState(
        () {
          _formDate = picked;
          _formDateController.text = FormHelper.formatDate(picked);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextFormField(
                    controller: _formDateController,
                    style: new TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: new InputDecoration(
                      labelText: "Date",
                    ),
                  ),
                ),
                new IconButton(
                  icon: new Icon(Icons.date_range),
                  onPressed: () => selectDate(context),
                ),
              ],
            ),
            new Expanded(
              child: new TextFormField(
                controller: _staffNameController,
                style: new TextStyle(fontSize: 20.0, color: Colors.black),
                decoration: new InputDecoration(
                  labelText: "Staff",
                ),
              ),
            ),
          ],
        ));
  }
}
