part of nixon_app;

final CollectionReference inspectionCollection =
    Firestore.instance.collection('Inspection');

class InspectionRepos {
  Future<List<Inspection>> list() async {
    QuerySnapshot snapshot = await inspectionCollection
        .where('userid', isEqualTo: _user.uid)
        .getDocuments();

    List<Inspection> inspectionList = snapshot.documents.map((document) {
      return Inspection.fromDocument(document);
    }).toList();
    return inspectionList;
  }

  Future<void> addInspection(BuildContext context, Inspection item) async {
    print('creating');
    item.userid = _user.uid;
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

  Future<bool> deleteInspectionbySnapshot(DocumentSnapshot snapshot) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(snapshot.reference);
    }).then((value) {
      return true;
    }).catchError((e) {
      return e;
    });
    return false;
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
