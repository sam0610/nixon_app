import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helper/formHelper.dart';
import '../Helper/AnimatedPageRoute.dart';
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
      body: new InspectionBody(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _addNew,
      ),
    );
  }
}

class InspectionBody extends StatelessWidget {
  void _open(BuildContext context, Inspection inspection) {
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new InspectionForm(inspection),
          ),
        );
  }

  void _delete(BuildContext context, String docid) {
    inspectionRepos.deleteInspection(docid).then((bool result) {
      FormHelper.showAlertDialog(context, "Deleted", 'Successful');
    }).catchError((onError) => FormHelper.showAlertDialog(
        context, "Error on Save", onError.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Inspection').snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new Column(
              children: <Widget>[
                new CircularProgressIndicator(),
                new Text("Loading....")
              ],
            ));
          }
          if (snapshot.data.documents.length == 0) {
            return new Center(
                child: new Column(
              children: <Widget>[new Text("no Data")],
            ));
          }
          final int _count = snapshot.data.documents.length;
          return new ListView.builder(
            itemCount: _count,
            itemBuilder: (_, int index) {
              final DocumentSnapshot document = snapshot.data.documents[index];
              final Inspection inspection = Inspection.fromDocument(document);
              return new ListTile(
                title: new Text(
                  FormHelper.formatDate(inspection.inspectionDate),
                ),
                subtitle: new Text(inspection.id.toString()),
                trailing: new Row(
                  children: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.edit),
                        onPressed: () => _open(context, inspection)),
                    new IconButton(
                        icon: new Icon(Icons.delete),
                        onPressed: () => _delete(context, document.documentID)),
                  ],
                ),
              );
            },
          );
        });
  }
}

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
      Inspection inspection =
          new Inspection(_formDate, _staffNameController.text);
      inspectionRepos.addInspection(inspection).then((bool result) {
        Navigator.pop(context);
      }).catchError((onError) => FormHelper.showAlertDialog(
          context, "Error on Save", onError.toString()));
    } else {
      Inspection inspection = new Inspection(
          _formDate, _staffNameController.text,
          id: widget.inspection.id, userid: widget.inspection.userid);
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
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: new DateTime(DateTime.now().year),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
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
