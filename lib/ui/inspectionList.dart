import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helper/AnimatedPageRoute.dart';
import '../Models/Inspection.dart';
import '../Models/InspectionRepository.dart';
import 'inspectionForm.dart';

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
            builder: (_) => new InspectionForm(form: new Inspection()),
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
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('Inspection').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return FirestoreListView(documents: snapshot.data.documents);
        });
  }
}

class FirestoreListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  void _open(BuildContext context, Inspection inspection) {
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new InspectionForm(form: inspection),
          ),
        );
  }

  void _delete(DocumentReference reference) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      await transaction.delete(snapshot.reference);
    });
  }

  FirestoreListView({this.documents});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 90.0,
      itemBuilder: (BuildContext context, int index) {
        Inspection inspection = new Inspection.fromJson(documents[index].data);
        String title = inspection.inspectionDate.toIso8601String();

        return new Card(
          child: new Row(
            children: <Widget>[
              new Expanded(child: new Text(title)),
              new IconButton(
                  icon: new Icon(Icons.edit),
                  onPressed: () => _open(context, inspection)),
              new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () {
                  _delete(documents[index].reference);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
