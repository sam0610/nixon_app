part of nixon_app;

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser _user;

class AuthHelper {
  static Future<void> setCurrentUser(FirebaseUser user) async {
    _user = user;
    if (user != null && user.displayName == null) {
      await updateProfileName("not set").then((_) => updateUserProfile());
    }
  }

  static Future<FirebaseUser> loginUser(
      {@required String email, @required String password}) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  static Future<bool> registerUser(
      {@required String email,
      @required String password,
      @required String name}) async {
    assert(email.contains("nixon.com.hk"));
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    user.sendEmailVerification();

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      UserUpdateInfo updateInfo = new UserUpdateInfo();
      updateInfo.displayName = name;
      FirebaseAuth.instance
          .updateProfile(updateInfo)
          .then((_) => FirebaseAuth.instance.signOut());
    });

    return user != null;
  }

  static Future<void> resetPassword({@required String email}) async {
    return _auth
        .sendPasswordResetEmail(email: email)
        .catchError((onError) => print(onError));
  }

  static void updateUserProfile() {
    _auth.currentUser().then((user) => _user = user);
  }

  static void logout() async {
    await _auth.signOut().then((_) {
      _user = null;
    });
  }

  static Future<void> updateProfileName(String name) async {
    if (name.length > 0 && _user.displayName != name) {
      UserUpdateInfo updateInfo = new UserUpdateInfo();
      updateInfo.displayName = name;
      await FirebaseAuth.instance.updateProfile(updateInfo);
      updateUserProfile();
    }
  }
}
