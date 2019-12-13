import 'package:den_store_dag/shared/shared.dart';
import 'package:den_store_dag/widgets/pincode.dart';
import 'package:den_store_dag/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  FirebaseUser _currentUser;

  String _verificationId;
  List<Guest> _guests;

  String _group;
  String _phoneNumber;
  String _smsCode;

  bool _showGroup = true;
  bool _showPhoneNumber = false;
  bool _showSmsCode = false;
  bool _showAttending = false;

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
        decoration: BoxDecoration(),
        child: Wrap(
          spacing: 20,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: [
            Text(
              'Log ind for at starte',
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            _showGroup
                ? new Pincode(
                    length: 1,
                    inputType: TextInputType.text,
                    onPressed: (newValue) {
                      setState(() {
                        _group = newValue;
                      });
                    })
                : new Container(),
            _showGroup
                ? Button(
                    text: 'TJEK AKTIVERINGSKODE',
                    onPressed: () {
                      _verifyGroup();
                    },
                  )
                : new Container(),
            _showPhoneNumber
                ? new Pincode(
                    length: 8,
                    inputType: TextInputType.phone,
                    onPressed: (newValue) {
                      setState(() {
                        _phoneNumber = newValue;
                      });
                    })
                : new Container(),
            _showPhoneNumber
                ? Button(
                    text: 'SEND SMS KODE',
                    onPressed: () {
                      _verifyPhoneNumber();
                    })
                : new Container(),
            _showSmsCode
                ? new Pincode(
                    length: 6,
                    inputType: TextInputType.number,
                    onPressed: (newValue) {
                      setState(() {
                        _smsCode = newValue;
                      });
                    })
                : new Container(),
            _showSmsCode
                ? Button(
                    text: 'LOG IND',
                    onPressed: () {
                      _signInWithPhoneNumber();
                    },
                  )
                : new Container(),
            _showAttending
                ? Column(
                    children: <Widget>[
                      for (var guest in _guests)
                        FlatButton(
                          child: Text(guest.name),
                          onPressed: () {
                            _claimUser(guest);
                          },
                        )
                    ],
                  )
                : new Container(),
          ],
        ),
      ),
    );
  }

  void _verifyGroup() async {
    _guests = (await Global.guestsRef.getData())
        .where((guests) => guests.group == _group)
        .toList();

    if (_guests.isNotEmpty) {
      setState(() {
        _showGroup = false;
        _showPhoneNumber = true;
      });
    } else {
      setState(() {
        _showGroup = true;
        _showPhoneNumber = false;
      });
      FlushbarHelper.createError(
              message: 'Forkert kode, prøv igen', title: 'Fejl')
          .show(context);
    }
  }

  // Example code of how to verify phone number
  void _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth.signInWithCredential(phoneAuthCredential);
      FlushbarHelper.createInformation(
              message: 'Received phone auth credential: $phoneAuthCredential',
              title: 'Bemærk')
          .show(context);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      FlushbarHelper.createError(
              message:
                  'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
              title: 'Fejl')
          .show(context);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      FlushbarHelper.createInformation(
              message:
                  "Om et øjeblik vil du modtage en SMS med en aktiveringskode",
              title: 'Bemærk')
          .show(context);
      setState(() {
        _verificationId = verificationId;
        _showPhoneNumber = false;
        _showSmsCode = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      setState(() {
        _verificationId = verificationId;
      });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+45' + _phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsCode,
    );
    _user = (await _firebaseAuth.signInWithCredential(credential)).user;
    _currentUser = await _firebaseAuth.currentUser();

    setState(() {
      _showSmsCode = false;
      _showAttending = true;
    });
  }

  void _claimUser(Guest guest) async {
    auth.updateUserData(_user, _phoneNumber, guest);

    assert(_user.uid == _currentUser.uid);
    if (_user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
