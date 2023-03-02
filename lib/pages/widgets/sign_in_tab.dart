import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sacs_app/blocs/sign_in/bloc/sign_in_bloc.dart';
import 'package:sacs_app/theme.dart';

class SignInTab extends StatefulWidget {
  SignInTab({super.key});

  @override
  State<SignInTab> createState() => _SignInTabState();
}

class _SignInTabState extends State<SignInTab> {
  final _formKey = GlobalKey<FormState>();

  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();

  final _emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  bool obscureTextPassword = true;
  bool _formValid = false;

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(_) => BlocProvider(
        create: (context) => SignInBloc(
          authenticationRepository: context.read(),
          userRepository: context.read(),
          authCubit: context.read(),
        ),
        child: BlocConsumer<SignInBloc, SignInState>(
          builder: (context, state) => Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () {
                  final _isValid = _formKey.currentState?.validate() ?? false;
                  setState(() {
                    _formValid = _isValid;
                  });
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _formWidget(context),
                    _signInButton(context),
                  ],
                ),
              ),
              _forgotPasswordWidget()
            ],
          ),
          listener: (context, state) {
            _shouldCloseForSignedIn(context, state: state);
            _shouldShowErrorSignInDialog(context, state: state);
          },
        ),
      );

  Widget _formWidget(BuildContext context, {bool enabled = true}) => Padding(
        padding: EdgeInsets.only(bottom: 24, top: 8),
        child: Card(
          elevation: 2.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
            width: 280,
            child: Column(
              children: [
                _emailField(enabled: enabled),
                Divider(
                  height: 1,
                  indent: 8,
                ),
                _passwordField(context, enabled: enabled),
              ],
            ),
          ),
        ),
      );

  Widget _emailField({bool enabled = true}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: TextFormField(
          enabled: enabled,
          controller: _signInEmailController,
          focusNode: _focusNodeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Indirizzo Email",
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: CustomTheme.primaryColor,
              size: 22,
            ),
          ),
          validator: (value) {
            if (!RegExp(_emailRegex).hasMatch(value ?? '')) {
              return 'Email non valida';
            }
          },
        ),
      );

  Widget _passwordField(BuildContext context, {bool enabled = true}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: TextFormField(
          enabled: enabled,
          controller: _signInPasswordController,
          focusNode: _focusNodePassword,
          obscureText: obscureTextPassword,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Password",
            hintStyle: TextStyle(fontSize: 17),
            errorStyle: TextStyle(fontSize: 12, height: 0.1),
            icon: Icon(
              FontAwesomeIcons.lock,
              color: CustomTheme.primaryColor,
              size: 22.0,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscureTextPassword = !obscureTextPassword;
                });
              },
              child: Icon(
                obscureTextPassword
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: CustomTheme.primaryColor,
                size: 15.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.length < 8) {
              return 'Password troppo corta';
            }
          },
          textInputAction: TextInputAction.go,
        ),
      );

  Widget _signInButton(BuildContext context, {bool loading = false}) =>
      ElevatedButton(
        onPressed: _formValid
            ? () => BlocProvider.of<SignInBloc>(context).performSignIn(
                _signInEmailController.text, _signInPasswordController.text)
            : null,
        style: ButtonStyle(
          backgroundColor: _formValid
              ? MaterialStateProperty.all<Color>(CustomTheme.primaryColor)
              : MaterialStateProperty.all<Color>(
                  Colors.grey.withOpacity(0.3),
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0),
          child: !loading
              ? Text(
                  "ACCEDI",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600),
                )
              : SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
        ),
      );

  Widget _forgotPasswordWidget() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Hai dimenticato la password?',
          ),
        ),
      );

  void _shouldCloseForSignedIn(BuildContext context,
      {required SignInState state}) {
    if (WidgetsBinding.instance != null) {
      context.router.popUntilRoot();
    }
  }

  void _shouldShowErrorSignInDialog(BuildContext context,
      {required SignInState state}) {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (state is ErrorSignInState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Credenziali Errate'),
                content: Text('Le credenziali fornite sono errate'),
                actions: [
                  TextButton(
                    onPressed: () => context.router.pop(),
                    child: Text('Ok'),
                  ),
                ],
              ),
            );
          }
        },
      );
    }
  }
}
