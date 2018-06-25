part of nixon_app;

final CollectionReference inspectionCollection =
    Firestore.instance.collection('Inspection');

final StorageReference audioStorageRef =
    FirebaseStorage.instance.ref().child('audios').child(_user.uid);

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

  static Future<Map<int, int>> countFormbyStaff(String yyyymm) async {
    QuerySnapshot snapshot = await inspectionCollection
        .where('yyyymm', isEqualTo: yyyymm)
        .getDocuments();

    Map<int, int> result = {};
    snapshot.documents.map((document) {
      int nixonNumber = document.data['nixonNumber'] != null
          ? document.data['nixonNumber'] as int
          : 0;

      result.putIfAbsent(nixonNumber, () => 0);

      if (result.containsKey(nixonNumber)) {
        result[nixonNumber] += 1;
      }
    }).toList();

    return result;
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

  static Future<void> changeInspectionStatus(
    DocumentSnapshot snapshot,
    InspectionStatus desiredStatus,
  ) async {
    print('change: ${snapshot.data['id']} to $desiredStatus');
    if (snapshot.data['status'] == InspectionStatus.composing.toString())
      return;

    //var oldDoc = await inspectionCollection.document(item.id).get();
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.update(snapshot.reference,
          {'status': desiredStatus.toString()}).catchError((e) => throw e);
    });
  }

  static Future<void> updateInspection(Inspection item) async {
    print('updating' + item.id);
    var oldDoc = await inspectionCollection.document(item.id).get();
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(oldDoc.reference);
      if (snapshot.exists) {
        await transaction.set(snapshot.reference, item.toJson());
        //await transaction.update(snapshot.reference, item.toJson());
      }
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
    StorageReference ref = audioStorageRef.child(name);
    StorageMetadata metadata =
        new StorageMetadata(contentType: 'Audio', contentEncoding: 'aac');
    StorageUploadTask uploadTask = ref.putFile(file, metadata);
    Uri downloadUrl = (await uploadTask.future).downloadUrl;

    return downloadUrl.toString();
  }

  static Future<void> deleteAudio(String name) async {
    StorageReference ref = audioStorageRef.child(name);
    await ref.delete();
  }
}
