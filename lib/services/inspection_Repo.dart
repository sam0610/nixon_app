part of nixon_app;

final CollectionReference inspectionCollection =
    Firestore.instance.collection('Inspection');

final Query inspectionByUser =
    inspectionCollection.where('userid', isEqualTo: _user.uid);

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

  static Future<void> addInspection(Inspection item) async {
    print('creating');
    item.userid = _user.uid;
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference = inspectionCollection;
      await reference.add(item.toJson()).then((docRef) {
        docRef.documentID;
        docRef.updateData({"id": docRef.documentID});
      }).catchError((e) => throw e);
    });
  }

  static Future<void> archiveInspection(Inspection item, bool archive) async {
    print('archive' + item.id);
    if (item.status == InspectionStatus.composing.toString()) {
      throw "composing item cannot be archive ";
    }

    item.status = archive
        ? InspectionStatus.archived.toString()
        : InspectionStatus.complete.toString();
    var oldDoc = await inspectionCollection.document(item.id).get();
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(oldDoc.reference);
      transaction.set(snapshot.reference, item.toJson());
      await transaction.update(snapshot.reference, item.toJson());
    }).catchError((e) => throw e);
  }

  static Future<void> updateInspection(Inspection item) async {
    print('updating' + item.id);
    var oldDoc = await inspectionCollection.document(item.id).get();
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(oldDoc.reference);
      transaction.set(snapshot.reference, item.toJson());
      await transaction.update(snapshot.reference, item.toJson());
    }).catchError((e) => throw e);
  }

  static Future<bool> deleteInspectionbySnapshot(
      DocumentSnapshot snapshot) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(snapshot.reference);
    }).then((value) {
      return true;
    }).catchError((e) {
      return e;
    });
    return false;
  }

  static Future<bool> deleteInspection(String docid) async {
    print('deleting');
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = inspectionCollection;
      await reference.document(docid).delete();
    }).then((value) {
      return true;
    });
    return false;
  }

  static Future<String> uploadAudios(File file, String name) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child(_user.uid).child(name);
    StorageMetadata metadata =
        new StorageMetadata(contentType: 'Audio', contentEncoding: 'aac');
    StorageUploadTask uploadTask = ref.putFile(file, metadata);

    Uri downloadUrl = (await uploadTask.future).downloadUrl;
    return downloadUrl.toString();
  }

  static Future<void> deletesAudio(String name) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child(_user.uid).child(name);
    await ref.delete();
  }
}
