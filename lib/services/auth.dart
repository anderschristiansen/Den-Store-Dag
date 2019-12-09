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

  // Future<void> updateUserData(FirebaseUser user) {
  //   DocumentReference reportRef = _db.collection('reports').document(user.uid);
  //   return reportRef.setData({'uid': user.uid, 'lastActivity': DateTime.now()}, merge: true);
  // }

  Future<void> updateUserData(FirebaseUser user, String phoneNumber, Guest guest) async {
    // var guests = (await Global.guestsRef.getData())
    //     .where((guests) => guests.id == guest.id && guests.name == guest.name)
    //     .toList();


    DocumentReference guestRef = _db.collection('guests').;

    // return doc.setData({'uid': user.uid, 'phoneNumber': phoneNumber, 'claimed': true});
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

// keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
