import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String name;
  String image;
  int order;
  DateTime start;
  DateTime end;

  Event({this.id, this.name, this.image, this.order, this.start, this.end});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Event(
      id: doc.documentID,
      name: data['name'],
      image: data['image'],
      order: data['order'],
      start: (data['start'] as Timestamp).toDate(),
      end: (data['end'] as Timestamp).toDate(),
    );
  }
}

class Gift {
  String id;
  String invite;
  String name;
  String image;
  String web;
  int price;

  Gift({this.id, this.invite, this.name, this.image, this.web, this.price});

  factory Gift.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Gift(
      id: doc.documentID,
      invite: data['invite'],
      name: data['name'],
      image: data['image'],
      web: data['web'],
      price: data['price'] ?? 0,
    );
  }
}

class Invite {
  String id;
  String name;

  Invite({this.id, this.name});

  factory Invite.fromMap(Map data) {
    return Invite(id: data['id'], name: data['name']);
  }
}

class User {
  final String uid;
  User({this.uid});
}

class UserData {
  String uid;
  String name;
  String phoneNumber;
  String invite;
  bool claimed;

  UserData({this.uid, this.name, this.phoneNumber, this.invite, this.claimed});

  UserData.fromMap(Map data) {
    uid = data['uid'];
    name = data['name'] ?? '';
    phoneNumber = data['phoneNumber'] ?? '';
    invite = data['invite'] ?? '';
    claimed = data['claimed'] ?? false;
  }
}
