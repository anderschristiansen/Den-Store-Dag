import 'package:den_store_dag/shared/shared.dart';
import 'package:den_store_dag/widgets/pincode.dart';
import 'package:den_store_dag/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;

  String _verificationId;
  List<Invite> _invites;

  String _inviteId;
  String _phoneNumber;
  String _smsCode;
  Invite _invite;

  bool _showInvite = true;
  bool _showPhoneNumber = false;
  bool _showSmsCode = false;
  bool _showUser = false;

  @override
  Widget build(BuildContext context) {
    _invites = Provider.of<List<Invite>>(context);

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
            _showInvite
                ? new Pincode(
                    length: 1,
                    inputType: TextInputType.text,
                    onPressed: (newValue) {
                      setState(() {
                        _inviteId = newValue;
                      });
                    })
                : new Container(),
            _showInvite
                ? Button(
                    text: 'TJEK AKTIVERINGSKODE',
                    onPressed: () {
                      _verifyInvite();
                    },
                  )
                : new Container(),
            _showUser
                ? Column(
                    children: <Widget>[
                      for (var invite in _invites)
                        FlatButton(
                          child: Text(invite.name),
                          onPressed: () {
                            _invite = invite;
                            setState(() {
                              _showPhoneNumber = true;
                              _showUser = false;
                            });
                          },
                        )
                    ],
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
          ],
        ),
      ),
    );
  }

  void _verifyInvite() async {
    bool verified = _invites.where((doc) => doc.id == _inviteId).isNotEmpty;

    if (verified) {
      setState(() {
        _showInvite = false;
        _showUser = true;
      });
    } else {
      setState(() {
        _showInvite = true;
        _showUser = false;
      });
      FlushbarHelper.createError(
              message: 'Forkert kode, prøv igen', title: 'Fejl')
          .show(context);
    }
  }

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
    await DatabaseService(uid: _user.uid)
        .updateUserData(_invite.name, _phoneNumber, _invite.id, true);
  }
}
