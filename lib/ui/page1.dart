import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nixon_app/Helper/Route.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => new _Page1State();
}

class _Page1State extends State<Page1> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // void _submit() {
  //   Firestore.instance
  //       .collection('todos')
  //       .document()
  //       .setData({'title': titleController.text, 'type': typeController.text});
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("new Page"),
          backgroundColor: Theme.of(context).primaryColor),
      body: new StreamBuilder(
        stream: Firestore.instance.collection("todos").snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Center(child: new Text("Loading"));
          return new ListView(
            children: snapshot.data.documents.map(
              (data) {
                return new ListTile(
                    title: new Text(data['title']),
                    subtitle: new Text(data['type']),
                    onTap: () => Navigator.of(context).push(new AnimatedRoute(
                        builder: (_) => new FormScreen(
                            id: data
                                .documentID))) // "${FormScreen.routeName}/${data.documentID}"),
                    );
              },
            ).toList(),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('todos')
              .document()
              .setData({'title': 'yychoi', 'type': 'dog', 'year': '2018'});
        },
      ),
    );
  }
}

class FormScreen extends StatefulWidget {
  final String id;
  static String routeName = "form-screen";

  FormScreen({this.id});

  @override
  _FormScreenState createState() => new _FormScreenState(id: id);
}

class Todos {
  String title;
  String type;
  int year;
}

class _FormScreenState extends State<FormScreen> {
  String id;
  Todos user = new Todos();
  final formKey = new GlobalKey<FormState>();

  _FormScreenState({this.id});

  ///On save action
  _onSave() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      Firestore.instance
          .collection('todos')
          .document(id)
          .setData({'title': user.title, 'type': user.type, 'year': user.year});
      Navigator.pop(context);
    }
  }

  _delete() {
    Navigator.pop(context);
    Firestore.instance.collection('todos').document(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Form"), actions: [
        new FlatButton(
          onPressed: () => _onSave(),
          child: new Text("Save"),
        ),
        new FlatButton(
          onPressed: () => _delete(),
          child: new Icon(Icons.delete),
        ),
      ]),
      body: new StreamBuilder(
          stream: Firestore.instance.collection("todos").document(id).snapshots,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return new Center(child: new Text("Loading Form"));
            user.title = snapshot.data['title'];
            user.type = snapshot.data['type'];
            return new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new TextFormField(
                    initialValue: "${user.title}",
                    decoration: new InputDecoration(
                        labelText: 'title',
                        hintText: "title name",
                        icon: new Icon(Icons.person_outline)),
                    validator: (val) =>
                        val.length == 0 ? 'Define title.' : null,
                    onSaved: (val) => user.title = val,
                  ),
                  new TextFormField(
                    initialValue: "${user.type}",
                    decoration: new InputDecoration(
                      labelText: 'type',
                      hintText: "type name",
                      icon: new Icon(Icons.person_outline),
                    ),
                    validator: (val) => val.length == 0 ? 'Define type.' : null,
                    onSaved: (val) => user.type = val,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
