import 'package:den_store_dag/shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
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

  final _guestIdController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _smsController = TextEditingController();

  bool _showGuestId = true;
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
        padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
        decoration: BoxDecoration(),
        child: Wrap(
          spacing: 20,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: [
            FlutterLogo(
              size: 150,
            ),
            Text(
              'Log ind for at starte',
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            _showGuestId
                ? TextField(
                    // decoration: _pinDecoration,
                    controller: _guestIdController,
                    textInputAction: TextInputAction.go,
                  )
                : new Container(),
            _showGuestId
                ? LoginButton(
                    text: 'TJEK AKTIVERINGSKODE',
                    icon: FontAwesomeIcons.code,
                    color: Colors.black45,
                    loginMethod: _verifyGuestId,
                  )
                : new Container(),
            _showPhoneNumber
                ? PinInputTextField(
                    pinLength: 8,
                    // decoration: _pinDecoration,
                    controller: _phoneNumberController,
                    autoFocus: true,
                    textInputAction: TextInputAction.go,
                    onSubmit: (pin) {
                      debugPrint('submit pin:$pin');
                    },
                  )
                : new Container(),
            _showPhoneNumber
                ? LoginButton(
                    text: 'SEND SMS KODE',
                    icon: FontAwesomeIcons.phone,
                    color: Colors.black45,
                    loginMethod: _verifyPhoneNumber,
                  )
                : new Container(),
            _showSmsCode
                ? PinInputTextField(
                    pinLength: 6,
                    controller: _smsController,
                    autoFocus: true,
                    textInputAction: TextInputAction.go,
                    onSubmit: (pin) {
                      debugPrint('submit pin:$pin');
                    },
                  )
                : new Container(),
            _showSmsCode
                ? LoginButton(
                    text: 'LOG IND',
                    icon: FontAwesomeIcons.phone,
                    color: Colors.black45,
                    loginMethod: _signInWithPhoneNumber,
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

  void _verifyGuestId() async {
    _guests = (await Global.guestsRef.getData())
        .where((guests) => guests.id == _guestIdController.text)
        .toList();

    if (_guests.isNotEmpty) {
      setState(() {
        _showGuestId = false;
        _showPhoneNumber = true;
      });
    } else {
      setState(() {
        _showGuestId = true;
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
        phoneNumber: '+45' + _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    _user = (await _firebaseAuth.signInWithCredential(credential)).user;
    _currentUser = await _firebaseAuth.currentUser();

    setState(() {
      _showSmsCode = false;
      _showAttending = true;
    });
  }

  void _claimUser(Guest guest) async {
    auth.updateUserData(_user, _phoneNumberController.text, guest);

    assert(_user.uid == _currentUser.uid);
    if (_user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(30),
        icon: Icon(icon, color: Colors.white),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
