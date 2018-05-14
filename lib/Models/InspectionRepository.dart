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

  Future<void> addInspection(Inspection item) async {
    print('creating');
    item.userid = user.uid;
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference = inspectionCollection;
      await reference.add(item.toJson()).then((docRef) {
        docRef.documentID;
        docRef.updateData({"id": docRef.documentID});
      });
    });
  }

  Future<void> updateInspection(Inspection item) async {
    print('updating' + item.id);
    var oldDoc = await inspectionCollection.document(item.id).get();
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(oldDoc.reference);
      await transaction.update(snapshot.reference, item.toJson());
    });
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
