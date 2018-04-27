import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  void _submit() {
    Firestore.instance
        .collection('todos')
        .document()
        .setData({'title': titleController.text, 'type': typeController});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("new Page"),
          backgroundColor: Theme.of(context).primaryColor),
      body: Container(
        child: new Center(
          child: new Column(
            new TextFormField(
              controller: titleController,
            ),
            new TextFormField(
              controller: typeController,
            ),
            new MaterialButton(
              child: new Text("submit"),
              onPressed: _submit,
            ),
          ),
        ),
      ),
    );
  }
}
