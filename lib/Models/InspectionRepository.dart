import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
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

  Future<bool> addInspection(Inspection item) async {
    print('creating');
    var newdoc = await inspectionCollection.document().get();
    item.id = newdoc.documentID;
    item.userid = user.uid;

    newdoc.reference.setData(item.toJson()).then((__) {
      return true;
    }).catchError((error) {
      print(error.toString());
    });
    return false;
  }

  Future<bool> updateInspection(Inspection item) async {
    print('updating' + item.id);
    var olddoc = await inspectionCollection.document(item.id).get();
    if (olddoc.exists && item.userid == user.uid) {
      olddoc.reference.setData(item.toJson(), SetOptions.merge).then((__) {
        return true;
      }).catchError((error) {
        return error;
      });
    } else {
      throw Exception('permission denied');
    }
    return false;
  }

  Future<bool> deleteInspection(String docid) async {
    print('deleting');
    inspectionCollection.document(docid).delete().then((__) {
      return true;
    }).catchError((error) {
      print(error.toString());
    });
    return false;
  }
}
