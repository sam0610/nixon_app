import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helper/formHelper.dart';
import '../Helper/Route.dart';
import '../Models/Inspection.dart';
import '../Models/InspectionRepository.dart';

InspectionRepos inspectionRepos;

class InspectionRecord extends StatefulWidget {
  @override
  _InspectionRecordState createState() => new _InspectionRecordState();
}

class _InspectionRecordState extends State<InspectionRecord> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null)
        inspectionRepos = new InspectionRepos.forUser(user: user);
    });
  }

  void _addNew() {
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new InspectionForm(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("inspectionList"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: new InspectionList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: _addNew,
      ),
    );
  }
}

class InspectionList extends StatelessWidget {
  void _open(BuildContext context, Inspection inspection) {
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new InspectionForm(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('Inspection').snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading....");
          }
          if (snapshot.data.documents.length == 0) {
            return new Text("No Data");
          }
          return new ListView(
            children: snapshot.data.documents.map((document) {
              Inspection inspection = Inspection.fromDocument(document);
              return new ListTile(
                title: new Text(
                  FormHelper.formatDate(inspection.inspectionDate),
                ),
                subtitle: new Text(inspection.userid.toString()),
                trailing: new IconButton(
                    icon: new Icon(Icons.edit),
                    onPressed: () => _open(context, inspection)),
              );
            }).toList(),
          );
        });
  }
}

class InspectionForm extends StatefulWidget {
  @override
  _InspectionFormState createState() => new _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  String userid;
  DateTime _formDate;

  @override
  void initState() {
    super.initState();
    _formDate ??= DateTime.now();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) userid = user.uid;
    });
  }

  void _save() {
    Inspection inspection = new Inspection(_formDate, userid);
    if (inspectionRepos.addInspection(inspection) == true)
      Navigator.pop(context);
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: new DateTime(DateTime.now().year),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _formDate) {
      setState(() {
        _formDate = picked;
      });
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
            )
          ]),
      body: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(FormHelper.formatDate(_formDate)),
              new IconButton(
                icon: new Icon(Icons.arrow_drop_down),
                onPressed: () => selectDate(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}
