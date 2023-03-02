import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sacs_app/cubits/auth/cubit/auth_cubit.dart';
import 'package:sacs_app/extensions/user_first_last_name.dart';
import 'package:sacs_app/models/app_user.dart';
import 'package:sacs_app/repositories/authentication_repository.dart';
import 'package:sacs_app/repositories/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthCubit authCubit;
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;
  SignInBloc({
    required this.authenticationRepository,
    required this.authCubit,
    required this.userRepository,
  }) : super(InitialSignInState()) {
    on<SignInEvent>(
      (event, emit) async {
        if (event is PerformSignInEvent) {
          emit(SigningInState());
          UserCredential? userCredential;
          try {
            userCredential = await authenticationRepository.signIn(
                email: event.email, password: event.password);
          } catch (error) {
            emit(ErrorSignInState());
          }
          if (userCredential != null) {
            emit(SuccessSignInState(userCredential));
          }
        }
      },
    );
  }

  void performSignIn(String email, String password) => add(
        PerformSignInEvent(email: email, password: password),
      );
//non in uso
  void _updateUserProfile(AuthenticatedState state) async {
    final User user = state.user;
    final firstName = user.firstName;
    final lastName = user.lastName;

    await userRepository.create(
      AppUser(
        id: user.uid,
        firstName: firstName,
        lastName: lastName,
        lastAccess: DateTime.now(),
      ),
    );
  }
}
