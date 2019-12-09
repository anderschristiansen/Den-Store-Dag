import 'package:flutter/material.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Global.userRef.getDocument(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          User user = snap.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: Text(user.name ?? 'Gæst'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // if (user.photoUrl != null)
                  // Container(
                  //   width: 100,
                  //   height: 100,
                  //   margin: EdgeInsets.only(top: 50),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     image: DecorationImage(
                  //       image: NetworkImage(user.photoUrl),
                  //     ),
                  //   ),
                  // ),
                  // Text(user.email ?? '', style: Theme.of(context).textTheme.headline),
                  // Spacer(),
                  // if (report != null)
                  //   Text('${report.total ?? 0}',
                  //       style: Theme.of(context).textTheme.display3),
                  // Text('Quizzes Completed',
                  //     style: Theme.of(context).textTheme.subhead),
                  // Spacer(),

                  FlatButton(
                      child: Text('Log ud'),
                      color: Colors.red,
                      onPressed: () async {
                        await auth.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      }),
                  Spacer()
                ],
              ),
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
