import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helper/formHelper.dart';
import '../Helper/AnimatedPageRoute.dart';
import '../Models/Inspection.dart';
import '../Models/InspectionRepository.dart';
import 'inspectionForm2.dart';

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
            builder: (_) => new InspectionForm2(form: new Inspection()),
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
            builder: (_) => new InspectionForm2(form: inspection),
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
                  FormHelper.datetoString(inspection.inspectionDate),
                ),
                subtitle: new Text(inspection.staffName.toString()),
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
