import 'package:den_store_dag/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'models.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      // updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<FirebaseUser> anonLogin() async {
    FirebaseUser user = (await _auth.signInAnonymously()).user;
    // updateUserData(user);
    return user;
  }

  Future<void> updateUserData(
      FirebaseUser user, String phoneNumber, Guest guest) async {
    DocumentReference userRef = _db.collection('users').document(user.uid);

    return userRef.setData({
      'phoneNumber': phoneNumber,
      'name': guest.name,
      'group': guest.id,
      'claimed': true
    });
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

// keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
