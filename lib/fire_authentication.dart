import 'package:firebase_auth/firebase_auth.dart';

class FireHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;

  get user => auth.currentUser;

  Future<String?> signUp({required String mail, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      return null; // means user added successfully
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
    }
}
  Future<String?> signIn({required String mail, required String pass}) async {
    try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mail,
          password: pass
      );
     return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
