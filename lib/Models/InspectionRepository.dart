import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'Inspection.dart';

class InspectionRepos {
  final FirebaseUser user;

  InspectionRepos.forUser({
    @required this.user,
  }) : assert(user != null);

  CollectionReference inspectionCollection =
      Firestore.instance.collection('Inspection');

  Future<List<Inspection>> list(String userid) async {
    QuerySnapshot snapshot = await inspectionCollection
        .where('userid', isEqualTo: userid)
        .getDocuments();
    List<Inspection> inspectionList = snapshot.documents.map((document) {
      return Inspection.fromDocument(document);
    }).toList();
    return inspectionList;
  }

  Stream<QuerySnapshot> listSnapshot({int limit, int offset}) {
    Stream<QuerySnapshot> snapshots =
        inspectionCollection.where('uid', isEqualTo: user.uid).snapshots;
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      // TODO can probably use _query.limit in an intelligent way with offset
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  bool addInspection(Inspection item) {
    inspectionCollection.document().setData(item.toJson()).then((__) {
      return true;
    }).catchError((error) {
      print(error.toString());
    });
    return false;
  }
}
