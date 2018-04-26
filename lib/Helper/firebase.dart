import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  String _displayName;
  String _email;
  String _uid;
  String _photoURL;

  UserData(FirebaseUser user) {
    this._uid = user.uid;
    this._email = user.email;
    user.displayName == null
        ? this._displayName = "N/A"
        : this._displayName = user.displayName;
    user.photoUrl == null
        ? this._photoURL = "N/A"
        : this._photoURL = user.photoUrl;
  }

  String get displayName => _displayName;
  String get email => _email;
  String get uid => _uid;
  String get photoUrl => _photoURL;
}

class FireBaseHelper {
  UserData getUser(FirebaseUser user) {
    return new UserData(user);
  }

  void setDefaultName(FirebaseUser user) async {
    if (user.displayName == null) {
      await updateProfileName("no name");
    }
  }

  updateProfileName(String name) async {
    UserUpdateInfo updateInfo = new UserUpdateInfo();
    updateInfo.displayName = name;
    await FirebaseAuth.instance.updateProfile(updateInfo);
  }
}
