import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacs_app/cubits/auth/cubit/auth_cubit.dart';
import 'package:sacs_app/pages/handset_home_page.dart';
import 'package:sacs_app/pages/log_in_page.dart';
import 'desktop_home_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => state is LoadingAuthenticationState
          ? _loadingWidget()
          : state is AuthenticatedState
              ? screenSelector(state.user)
              : LoginPage(),
    );
  }

  Widget screenSelector(User user) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return HandsetHomePage(
              user: user,
            );
          } else
            return DesktopHomePage(
              user: user,
            );
        },
      );

  Widget _loadingWidget() => Scaffold(
        body: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
