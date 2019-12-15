import 'package:cloud_firestore/cloud_firestore.dart';

import 'services.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference inviteCollection =
      Firestore.instance.collection('invites');
  final CollectionReference giftCollection =
      Firestore.instance.collection('gifts');
  final CollectionReference eventCollection =
      Firestore.instance.collection('events');

  Future updateUserData(
      String name, String phoneNumber, String invite, bool claimed) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'phoneNumber': phoneNumber,
      'invite': invite,
      'claimed': claimed
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        phoneNumber: snapshot.data['phoneNumber'],
        invite: snapshot.data['invite'],
        claimed: snapshot.data['claimed']);
  }

  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<UserData>> streamUsers() {
    return userCollection.snapshots().map((list) =>
        list.documents.map((doc) => UserData.fromMap(doc.data)).toList());
  }

  // Future<bool> verifyInvite(String id) async {
  //   final QuerySnapshot result = await inviteCollection
  //       .where('id', isEqualTo: id)
  //       .limit(1)
  //       .getDocuments();
  //   final List<DocumentSnapshot> documents = result.documents;
  //   return documents.length == 1;
  // }

  Stream<List<Invite>> streamInvites() {
    return inviteCollection.snapshots().map((list) =>
        list.documents.map((doc) => Invite.fromMap(doc.data)).toList());
  }

  Stream<List<Gift>> streamGifts() {
    return giftCollection.snapshots().map((list) =>
        list.documents.map((doc) => Gift.fromFirestore(doc)).toList());
  }

  Future chooseGift(Gift gift, String invite) async {
    return await giftCollection
        .document(gift.id)
        .setData({'invite': invite}, merge: true);
  }

  Future releaseGift(Gift gift) async {
    return await giftCollection
        .document(gift.id)
        .setData({'invite': null}, merge: true);
  }

  Stream<List<Event>> streamEvents() {
    return eventCollection.snapshots().map((list) =>
        list.documents.map((doc) => Event.fromFirestore(doc)).toList());
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';
// import 'package:rxdart/rxdart.dart';
// import './globals.dart';

// class Document<T> {
//   final Firestore _db = Firestore.instance;
//   final String path;
//   DocumentReference ref;

//   Document({this.path}) {
//     ref = _db.document(path);
//   }

//   Future<T> getData() {
//     return ref.get().then((v) => Global.models[T](v.data) as T);
//   }

//   Stream<T> streamData() {
//     return ref.snapshots().map((v) => Global.models[T](v.data) as T);
//   }

//   Future<void> upsert(Map data) {
//     return ref.setData(Map<String, dynamic>.from(data), merge: true);
//   }
// }

// class Collection<T> {
//   final Firestore _db = Firestore.instance;
//   final String path;
//   CollectionReference ref;

//   Collection({this.path}) {
//     ref = _db.collection(path);
//   }

//   Future<List<T>> getData() async {
//     var snapshots = await ref.getDocuments();
//     return snapshots.documents
//         .map((doc) => Global.models[T](doc) as T)
//         .toList();
//   }

//   Stream<List<T>> streamData() {
//     return ref.snapshots().map(
//         (list) => list.documents.map((doc) => Global.models[T](doc.data) as T));
//   }
// }

// class UserData<T> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final String collection;

//   UserData({this.collection});

//   Stream<T> get documentStream {
//     return Observable(_auth.onAuthStateChanged).switchMap((user) {
//       if (user != null) {
//         Document<T> doc = Document<T>(path: '$collection/${user.uid}');
//         return doc.streamData();
//       } else {
//         return Observable<T>.just(null);
//       }
//     }); //.shareReplay(maxSize: 1).doOnData((d) => print('777 $d'));// as Stream<T>;
//   }

//   Future<T> getDocument() async {
//     FirebaseUser user = await _auth.currentUser();

//     if (user != null) {
//       Document doc = Document<T>(path: '$collection/${user.uid}');
//       return doc.getData();
//     } else {
//       return null;
//     }
//   }

//   Future<void> upsert(Map data) async {
//     FirebaseUser user = await _auth.currentUser();
//     Document<T> ref = Document(path: '$collection/${user.uid}');
//     return ref.upsert(data);
//   }
// }
