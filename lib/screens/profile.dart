import 'package:den_store_dag/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.deepOrange,
                title: Text(userData.name ?? 'Gæst'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton(
                        child: Text('Log ud'),
                        color: Colors.red,
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        }),
                    Spacer()
                  ],
                ),
              ),
            );
          } else {
            return Loader();
          }
        });
  }
}
