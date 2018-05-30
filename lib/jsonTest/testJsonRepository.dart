import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'testJson.dart';

final CollectionReference jsonCollection =
    Firestore.instance.collection('testJson');

class JsonRepos {
  final FirebaseUser user;

  JsonRepos.forUser({
    @required this.user,
  }) : assert(user != null);

  Stream<QuerySnapshot> getSnapshot() {
    return jsonCollection.snapshots();
  }

  Future<void> addJson(Master master) async {
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference = jsonCollection;
      await reference.add(master.toJson()).then((docRef) {
        docRef.documentID;
        docRef.updateData({"id": docRef.documentID});
      }).catchError((e) => print(e));
    });
  }

  Future<void> updateInspection(Master item) async {
    var oldDoc = await jsonCollection.document(item.id).get();
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(oldDoc.reference);
      await transaction.update(snapshot.reference, item.toJson());
    });
  }

  Future<bool> deleteInspection(String docid) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = jsonCollection;
      await reference.document(docid).delete();
    }).then((value) {
      return true;
    });
    return false;
  }
}
