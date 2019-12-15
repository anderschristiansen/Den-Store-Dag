import 'package:den_store_dag/screens/screens.dart';
import 'package:den_store_dag/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);

    if (user == null) {
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}