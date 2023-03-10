import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth firebaseAuth;
  late StreamSubscription<User?> _streamSubscription;
  AuthCubit({required this.firebaseAuth})
      : super(LoadingAuthenticationState()) {
    _streamSubscription = firebaseAuth.userChanges().listen(_onStateChanged);
  }

  void _onStateChanged(User? user) {
    if (user == null) {
      emit(NotAuthenticatedState());
    } else {
      emit(AuthenticatedState(user));
    }
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    return super.close();
  }

  void signOut() => firebaseAuth.signOut();
}
