import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

createuser({required String email, required String pass}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
    log('sucess');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

allogin({required String email, required String pass}) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
    log('sucess');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

logout() async {
  await FirebaseAuth.instance.signOut();
}

deleteAcc() async {
  User user = await FirebaseAuth.instance.currentUser!;
  user.delete();
}
