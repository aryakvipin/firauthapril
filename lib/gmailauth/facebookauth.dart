import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCiHv4jYzh-MjK3gDtMSODpphskb8PLgVI",
          appId: "1:1081792280860:android:426b42a86c0d65c542a2d9",
          messagingSenderId: "",
          projectId: "aprilfire-c4f43",
          storageBucket: "aprilfire-c4f43.appspot.com"));
  runApp(MaterialApp(
    home: GoogleSignInScreen(),
  ));
}
class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  Map<String,dynamic> ? _userdata;
  String welcome="facebook";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Google SignIn Screen')),
        body: Center(child: TextButton(onPressed: () {  }, child: Text("welcome"),)));
  }
  Future<UserCredential> signInWithfacebook() async {
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions:['email']);
      if(loginResult==LoginStatus.success){
        final userdata=await FacebookAuth.instance.getUserData();
        _userdata=userdata;
        setState(() {
          welcome=_userdata!['email'];
        });
      }
      else{
        print(loginResult.message);
      }
      final OAuthCredential oAuthcredential=FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      return FirebaseAuth.instance.signInWithCredential(oAuthcredential);


  }
  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}