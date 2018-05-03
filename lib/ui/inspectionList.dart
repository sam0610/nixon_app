import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../Helper/Route.dart';
import '../Models/Inspection.dart';

String _formatDate(DateTime value) {
  return new DateFormat("yyyy.MM.dd").format(value);
}

class InspectionRecord extends StatefulWidget {
  @override
  _InspectionRecordState createState() => new _InspectionRecordState();
}

class _InspectionRecordState extends State<InspectionRecord> {
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
                  _formatDate(inspection.inspectionDate),
                ),
                subtitle: new Text(inspection.userid.toString()),
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
    Firestore.instance
        .collection('Inspection')
        .document()
        .setData(inspection.toJson())
        .then((__) {
      Navigator.of(context).pop();
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
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
              new Text(_formatDate(_formDate)),
              new IconButton(
                icon: new Icon(Icons.arrow_drop_down_circle),
                onPressed: () => _selectDate(context),
              )
            ],
          )
        ],
      ),
    );
  }
}
