import 'dart:ui';
import 'package:den_store_dag/shared/shared.dart';
import 'package:den_store_dag/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/services.dart';

class GiftsScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var gifts = Provider.of<List<Gift>>(context);

    return Scaffold(
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        mainAxisSpacing: 30.0,
        crossAxisCount: 1,
        children: gifts.map((gift) => GiftItem(gift: gift)).toList(),
      ),
    );
  }
}

class GiftItem extends StatelessWidget {
  final Gift gift;
  const GiftItem({Key key, this.gift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    bool taken = gift.invite == null ? false : true;

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Hero(
              tag: gift.image,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            if (!taken) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GiftScreen(gift: gift),
                                ),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  gift.name,
                                  style: Theme.of(context).textTheme.headline,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                              Expanded(
                                child: taken
                                    ? Container(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: Container(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(gift.image),
                                                fit: BoxFit.contain)),
                                      )
                                    : Image.network(gift.image,
                                        fit: BoxFit.contain),
                              ),
                            ],
                          ),
                        )),
                  ),
                  gift.invite != null
                      ? gift.invite == userData.invite
                          ? Positioned(
                              bottom: 145,
                              top: 155,
                              right: 100,
                              left: 100,
                              child: Button(
                                  text: 'FRIGIV ØNSKE',
                                  onPressed: () async {
                                    await DatabaseService().releaseGift(gift);
                                  }))
                          : Positioned(
                              bottom: 145,
                              top: 155,
                              right: 100,
                              left: 100,
                              child: Button(
                                text: 'RESERVERET',
                                onPressed: () {},
                                color: Colors.grey,
                              ))
                      : Container()
                ],
              ),
            );
          } else {
            return Loader();
          }
        });
  }
}

class GiftScreen extends StatelessWidget {
  final Gift gift;
  const GiftScreen({Key key, this.gift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    bool taken = gift.invite == null ? false : true;

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(gift.name),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: gift.image,
                        child: Image.network(gift.image,
                            width: MediaQuery.of(context).size.width),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20.0)),
                      if (gift.web != null)
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 30),
                            child: FlatButton(
                              onPressed: _launchURL,
                              child: Text('Gå til hjemmeside'),
                            )),
                      taken
                          ? Button(
                              text: 'FRIGIV ØNSKE',
                              onPressed: () async {
                                await DatabaseService().releaseGift(gift);
                                Navigator.pop(context);
                              })
                          : Button(
                              text: 'VÆLG ØNSKE',
                              onPressed: () async {
                                await DatabaseService()
                                    .chooseGift(gift, userData.invite);
                                Navigator.pop(context);
                              })
                    ],
                  )),
            );
          } else {
            return Loader();
          }
        });
  }

  _launchURL() async {
    if (await canLaunch(gift.web)) {
      await launch(gift.web);
    } else {
      throw 'Could not launch ${gift.web}';
    }
  }
}

// class GiftList extends StatelessWidget {
//   final Gift gift;
//   GiftList({Key key, this.gift});

//   @override
//   Widget build(BuildContext context) {

//     return Column(
//         children: gift.quizzes.map((quiz) {
//       return Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//         elevation: 4,
//         margin: EdgeInsets.all(4),
//         child: InkWell(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (BuildContext context) => QuizScreen(quizId: quiz.id),
//               ),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(8),
//             child: ListTile(
//               title: Text(
//                 quiz.title,
//                 style: Theme.of(context).textTheme.title,
//               ),
//               subtitle: Text(
//                 quiz.description,
//                 overflow: TextOverflow.fade,
//                 style: Theme.of(context).textTheme.subhead,
//               ),
//               leading: QuizBadge(topic: topic, quizId: quiz.id),
//             ),
//           ),
//         ),
//       );
//     }).toList());
//   }
// }

// class TopicDrawer extends StatelessWidget {
//   final List<Topic> topics;
//   TopicDrawer({Key key, this.topics});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView.separated(
//           shrinkWrap: true,
//           itemCount: topics.length,
//           itemBuilder: (BuildContext context, int idx) {
//             Topic topic = topics[idx];
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(top: 10, left: 10),
//                   child: Text(
//                     topic.title,
//                     // textAlign: TextAlign.left,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ),
//                 QuizList(topic: topic)
//               ],
//             );
//           },
//           separatorBuilder: (BuildContext context, int idx) => Divider()),
//     );
//   }
// }
