import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sacs_app/cubits/auth/cubit/auth_cubit.dart';
import 'package:sacs_app/models/app_user.dart';
import 'package:sacs_app/repositories/authentication_repository.dart';
import 'package:sacs_app/repositories/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthCubit authCubit;
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;
  SignUpBloc({
    required this.authenticationRepository,
    required this.authCubit,
    required this.userRepository,
  }) : super(InitialSignUpState()) {
    on<SignUpEvent>(
      (event, emit) async {
        if (event is PerformSignUpEvent) {
          emit(SigningUpState());

          final authSubscription = authCubit.stream
              .where((state) => state is AuthenticatedState)
              .listen((state) => _updateUserProfile(event,
                  state: (state as AuthenticatedState)));
          UserCredential? userCredential;

          try {
            userCredential = await authenticationRepository.signUp(
                email: event.email, password: event.password);
          } catch (error) {
            emit(ErrorSignUpState());
          } finally {
            authSubscription.cancel();
          }

          if (userCredential != null) {
            emit(SuccessSignUpState(userCredential));
          }
        }
      },
    );
  }
  void _updateUserProfile(PerformSignUpEvent event,
      {required AuthenticatedState state}) async {
    final user = state.user;
    final firstName = event.firstName;
    final lastName = event.lastName;
    final displayName = '$firstName $lastName';
    await userRepository.create(
      AppUser(
        id: user.uid,
        firstName: firstName,
        lastName: lastName,
        lastAccess: DateTime.now(),
      ),
    );
    await user.updateDisplayName(displayName);
  }

  void performSignUp(
          String firstName, String lastName, String email, String password) =>
      add(
        PerformSignUpEvent(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        ),
      );
}
