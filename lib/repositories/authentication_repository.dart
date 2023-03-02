import 'package:firebase_auth/firebase_auth.dart';
import 'package:sacs_app/error/wrong_credentials_error.dart';

import '../exceptions/already_existing_account_error.dart';

class AuthenticationRepository {
  final FirebaseAuth firebaseAuth;

  AuthenticationRepository({required this.firebaseAuth});

  Future<UserCredential> signIn(
      {required String email, required String password}) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Utente inesistente'); //sostiuire con log di Fimber.
      } else if (e.code == 'wrong-password') {
        print('Password non valida'); //sostiuire con log di Fimber.
      }
      throw new WrongCredentialsException();
    }
  }

  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw new AlreadyExistingAccountException();
      }
    }
  }
}
