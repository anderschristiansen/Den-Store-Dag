import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        // StreamProvider<UserData>.value(value: db.userData),
        StreamProvider<List<Gift>>.value(value: db.streamGifts()),
        StreamProvider<List<Invite>>.value(value: db.streamInvites()),
        StreamProvider<List<Event>>.value(value: db.streamEvents()),
      ],
      child: MaterialApp(
        // Firebase Analytics
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],

        // Named Routes
        routes: {
          '/': (context) => WrapperScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
        },

        // Theme
        theme: ThemeData(
          fontFamily: 'Nunito',
          primaryColor: Colors.deepPurple,
          buttonColor: Colors.deepPurpleAccent,
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.black87,
          ),
          brightness: Brightness.light,
          textTheme: TextTheme(
            title: TextStyle(fontSize: 25),
            headline: TextStyle(fontSize: 20),
            subhead: TextStyle(color: Colors.grey),
            body1: TextStyle(fontSize: 18),
            body2: TextStyle(fontSize: 16),
            button: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
          buttonTheme: ButtonThemeData(),
        ),
      ),
    );
  }
}
