import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Helper/AnimatedPageRoute.dart';
import '../Helper/formHelper.dart';
import '../Models/testJson.dart';
import '../Models/testJsonRepository.dart';

class JsonTest extends StatefulWidget {
  @override
  _JsonTestState createState() => new _JsonTestState();
}

class _JsonTestState extends State<JsonTest> {
  JsonRepos repos;

  @override
  void initState() {
    super.initState();
    //    FormHelper.datetoString(myform.inspectionDate ?? new DateTime.now());
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) repos = new JsonRepos.forUser(user: user);

      _add();
    });
  }

  void _add() {
    Address address = new Address('Po Tei Road', '11', '303');
    Master master = new Master(null, DateTime.now(), 'samchoi', 'm', address);
    repos.addJson(master);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.add), onPressed: () => _add()),
        body: new StreamBuilder(
          stream: Firestore.instance.collection('testJson').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return FirestoreListView(documents: snapshot.data.documents);
          },
        ));
  }
}

class FirestoreListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  void _open(BuildContext context, Master master) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new MasterPage(master),
          ),
        );
    ;
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
        Master item = new Master.fromJson(documents[index].data);

        return new Card(
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new ListTile(
                    title: new Text(item.gender),
                    subtitle: new Text(item.name,
                        style: new TextStyle(fontSize: 20.0))),
              ),
              new IconButton(
                  icon: new Icon(Icons.edit),
                  onPressed: () => _open(context, item)),
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

class MasterPage extends StatefulWidget {
  MasterPage(this.master);
  final Master master;
  @override
  _MasterPageState createState() => new _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  Master master;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    master = widget.master;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Detail"),
        centerTitle: true,
        elevation: 8.0,
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new Text(master.id),
            new Text(master.name),
            new Text(master.gender),
            new Text(master.date.toIso8601String()),
            new Text(master.address.street),
            new Text(master.address.number),
            new Text(master.address.flate),
          ],
        ),
      ),
    );
  }
}
