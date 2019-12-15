import 'package:den_store_dag/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

// keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
