import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:nixon_app/Helper/formHelper.dart';
import 'Inspection.dart';

final CollectionReference inspectionCollection =
    Firestore.instance.collection('Inspection');

class InspectionRepos {
  final FirebaseUser user;

  InspectionRepos.forUser({
    @required this.user,
  }) : assert(user != null);

  Future<List<Inspection>> list() async {
    QuerySnapshot snapshot = await inspectionCollection
        .where('userid', isEqualTo: user.uid)
        .getDocuments();

    List<Inspection> inspectionList = snapshot.documents.map((document) {
      return Inspection.fromDocument(document);
    }).toList();
    return inspectionList;
  }

  Future<void> addInspection(BuildContext context, Inspection item) async {
    print('creating');
    item.userid = user.uid;
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference = inspectionCollection;
      await reference
          .add(item.toJson())
          .then((docRef) {
            docRef.documentID;
            docRef.updateData({"id": docRef.documentID});
          })
          .whenComplete(
              () => FormHelper.showAlertDialog(context, "done", "data saved"))
          .catchError((e) =>
              FormHelper.showAlertDialog(context, 'error', e.toString()));
    });
  }

  Future<void> updateInspection(BuildContext context, Inspection item) async {
    print('updating' + item.id);
    var oldDoc = await inspectionCollection.document(item.id).get();
    Firestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(oldDoc.reference);
          transaction.set(snapshot.reference, item.toJson());
          await transaction.update(snapshot.reference, item.toJson());
        })
        .whenComplete(
            () => FormHelper.showAlertDialog(context, "done", "data saved"))
        .catchError(
            (e) => FormHelper.showAlertDialog(context, 'error', e.toString()));
  }

  Future<bool> deleteInspection(String docid) async {
    print('deleting');
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = inspectionCollection;
      await reference.document(docid).delete();
    }).then((value) {
      return true;
    });
    return false;
  }
}
