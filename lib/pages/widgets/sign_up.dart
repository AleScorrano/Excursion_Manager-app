import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sacs_app/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:sacs_app/theme.dart';

class SignUpTab extends StatefulWidget {
  const SignUpTab({super.key});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final _formKey = GlobalKey<FormState>();

  final _signUpFirstNameController = TextEditingController();
  final _signUpLastNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

  final _focusNodeFirstNameField = FocusNode();
  final _focusNodeLastNameField = FocusNode();
  final _focusNodeConfirmPassword = FocusNode();
  final _focusNodeEmail = FocusNode();
  final _focuseNodepassword = FocusNode();

  final emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  bool _formValid = false;
  bool obscureTextPassword = true;
  bool obscureTextConfirmPassword = true;

  @override
  void dispose() {
    _focusNodeFirstNameField.dispose();
    _focusNodeLastNameField.dispose();
    _focusNodeEmail.dispose();
    _focuseNodepassword.dispose();
    _focusNodeConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => SignUpBloc(
            userRepository: context.read(),
            authenticationRepository: context.read(),
            authCubit: context.read()),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            _shouldCloseForSignedUp(context, state: state);
            _shouldShowErrorSignUpDialog(context, state: state);
          },
          builder: (context, state) => Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 8),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: () {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    setState(() {
                      _formValid = isValid;
                    });
                  },
                  child: Stack(
                    children: [
                      _formWidget(context),
                      _signUpButton(context, state: state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _formWidget(BuildContext context, {bool enabled = true}) => Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
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
                _firstNameField(enabled: enabled),
                Divider(height: 1, indent: 8),
                _lastNameField(enabled: enabled),
                Divider(height: 1, indent: 8),
                _emailField(enabled: enabled),
                Divider(height: 1, indent: 8),
                _passwordField(enabled: enabled),
                Divider(height: 1, indent: 8),
                _confirmPasswordfield(context, enabled: enabled),
              ],
            ),
          ),
        ),
      );

  Widget _signUpButton(BuildContext context, {required SignUpState state}) =>
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: _formValid
                ? () => BlocProvider.of<SignUpBloc>(context).performSignUp(
                      _signUpFirstNameController.text,
                      _signUpLastNameController.text,
                      _signUpEmailController.text,
                      _signUpPasswordController.text,
                    )
                : null,
            style: ButtonStyle(
              backgroundColor: _formValid
                  ? MaterialStateProperty.all<Color>(CustomTheme.primaryColor)
                  : MaterialStateProperty.all<Color>(
                      Colors.grey.withOpacity(0.3)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 48.0),
              child: state != SigningUpState
                  ? Text(
                      "INVIA",
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
          ),
        ),
      );

  Widget _firstNameField({bool enabled = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpFirstNameController,
          textCapitalization: TextCapitalization.words,
          focusNode: _focusNodeFirstNameField,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Nome",
            errorStyle: TextStyle(fontSize: 12, height: 0.1),
            hintStyle: TextStyle(fontSize: 17),
            icon: Icon(
              FontAwesomeIcons.user,
              color: CustomTheme.primaryColor,
              size: 22.0,
            ),
          ),
          onFieldSubmitted: (_) {
            _focusNodeLastNameField.requestFocus();
          },
        ),
      );

  Widget _lastNameField({bool enabled = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpLastNameController,
          textCapitalization: TextCapitalization.words,
          focusNode: _focusNodeLastNameField,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Cognome",
            errorStyle: TextStyle(fontSize: 12, height: 0.1),
            hintStyle: TextStyle(fontSize: 17),
            icon: Icon(
              FontAwesomeIcons.user,
              color: CustomTheme.primaryColor,
              size: 22.0,
            ),
          ),
          onFieldSubmitted: (_) {
            _focusNodeEmail.requestFocus();
          },
        ),
      );

  Widget _emailField({bool enabled = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpEmailController,
          focusNode: _focusNodeEmail,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Indirizzo Email",
            errorStyle: TextStyle(fontSize: 12, height: 0.1),
            hintStyle: TextStyle(fontSize: 17),
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: CustomTheme.primaryColor,
              size: 22.0,
            ),
          ),
          validator: (value) {
            if (!RegExp(emailRegex).hasMatch(value ?? '')) {
              return 'Email non valida';
            }
          },
          onFieldSubmitted: (_) {
            _focuseNodepassword.requestFocus();
          },
        ),
      );

  Widget _passwordField({bool enabled = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpPasswordController,
          focusNode: _focuseNodepassword,
          obscureText: obscureTextPassword,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Password",
            errorStyle: TextStyle(fontSize: 12, height: 0.1),
            hintStyle: TextStyle(fontSize: 17),
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
          onFieldSubmitted: (_) {
            _focusNodeConfirmPassword.requestFocus();
          },
        ),
      );

  Widget _confirmPasswordfield(BuildContext context, {bool enabled = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24),
        child: TextFormField(
          enabled: enabled,
          controller: _signUpConfirmPasswordController,
          focusNode: _focusNodeConfirmPassword,
          obscureText: obscureTextConfirmPassword,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Conferma Password",
            errorStyle: TextStyle(fontSize: 12, height: 0.1),
            hintStyle: TextStyle(fontSize: 17),
            icon: Icon(
              FontAwesomeIcons.lock,
              color: CustomTheme.primaryColor,
              size: 22.0,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscureTextConfirmPassword = !obscureTextConfirmPassword;
                });
              },
              child: Icon(
                obscureTextConfirmPassword
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: Colors.black,
                size: 15.0,
              ),
            ),
          ),
          validator: (value) {
            if (_signUpPasswordController.text != value) {
              return 'Le password non corrispondono';
            }
          },
        ),
      );

  void _shouldCloseForSignedUp(BuildContext context,
      {required SignUpState state}) {
    if (WidgetsBinding.instance != null) {
      context.router.popUntilRoot();
    }
  }

  void _shouldShowErrorSignUpDialog(BuildContext context,
      {required SignUpState state}) {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (state is ErrorSignUpState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Utente già registrato'),
                content: Text(
                    'Email già in uso,prova ad usare un altro indirizzo email'),
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
