import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> _handleSignIn(String _email, String _pw) async {
  FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: _email.toLowerCase(), password: _pw);
  print('signed in ' + user.displayName);
  return user;
}
