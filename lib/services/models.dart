// //// Embedded Maps

// class Option {
//   String value;
//   String detail;
//   bool correct;

//   Option({this.correct, this.value, this.detail});
//   Option.fromMap(Map data) {
//     value = data['value'];
//     detail = data['detail'] ?? '';
//     correct = data['correct'];
//   }
// }

// class Question {
//   String text;
//   List<Option> options;
//   Question({this.options, this.text});

//   Question.fromMap(Map data) {
//     text = data['text'] ?? '';
//     options =
//         (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
//   }
// }

// ///// Database Collections

// class Quiz {
//   String id;
//   String title;
//   String description;
//   String video;
//   String topic;
//   List<Question> questions;

//   Quiz(
//       {this.title,
//       this.questions,
//       this.video,
//       this.description,
//       this.id,
//       this.topic});

//   factory Quiz.fromMap(Map data) {
//     return Quiz(
//         id: data['id'] ?? '',
//         title: data['title'] ?? '',
//         topic: data['topic'] ?? '',
//         description: data['description'] ?? '',
//         video: data['video'] ?? '',
//         questions: (data['questions'] as List ?? [])
//             .map((v) => Question.fromMap(v))
//             .toList());
//   }
// }

// class Topic {
//   final String id;
//   final String title;
//   final String description;
//   final String img;
//   final List<Quiz> quizzes;

//   Topic({this.id, this.title, this.description, this.img, this.quizzes});

//   factory Topic.fromMap(Map data) {
//     return Topic(
//       id: data['id'] ?? '',
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       img: data['img'] ?? 'default.png',
//       quizzes: (data['quizzes'] as List ?? [])
//           .map((v) => Quiz.fromMap(v))
//           .toList(), //data['quizzes'],
//     );
//   }
// }

// class Report {
//   String uid;
//   int total;
//   dynamic topics;

//   Report({this.uid, this.topics, this.total});

//   factory Report.fromMap(Map data) {
//     return Report(
//       uid: data['uid'],
//       total: data['total'] ?? 0,
//       topics: data['topics'] ?? {},
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Gift {
  String id;
  String group;
  String name;
  String image;
  String web;
  int price;

  Gift({this.id, this.group, this.name, this.image, this.web, this.price});

  factory Gift.fromMap(Map data) {
    return Gift(
      id: '',
      group: data['group'],
      name: data['name'],
      image: data['image'],
      web: data['web'],
      price: data['price'] ?? 0,
    );
  }

  factory Gift.fromSnapshot(DocumentSnapshot doc) {
    var data = doc.data;
    return Gift(
      id: doc.documentID,
      group: data['group'],
      name: data['name'],
      image: data['image'],
      web: data['web'],
      price: data['price'] ?? 0,
    );
  }
}

class Guest {
  String id;
  String group;
  String name;

  Guest({this.id, this.group, this.name});

  factory Guest.fromSnapshot(DocumentSnapshot doc) {
    var data = doc.data;
    return Guest(id: doc.documentID, group: data['group'], name: data['name']);
  }
}

class User {
  // String uid;
  String name;
  String phoneNumber;
  String group;
  bool claimed;

  User({this.name, this.phoneNumber, this.group, this.claimed});

  User.fromMap(Map data) {
    name = data['name'] ?? '';
    phoneNumber = data['phoneNumber'] ?? '';
    group = data['group'] ?? '';
    claimed = data['claimed'] ?? false;
  }
}
