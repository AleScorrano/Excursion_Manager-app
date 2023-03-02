import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:sacs_app/misc/bubble_indicator_painter.dart';
import 'package:sacs_app/pages/widgets/sign_in_tab.dart';
import 'package:sacs_app/pages/widgets/sign_up.dart';
import 'package:sacs_app/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PageController _pageController;
  Color signiInColor = Colors.black;
  Color signUpColor = Colors.white;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomTheme.complementaryColor2,
                CustomTheme.seconadaryColorLight,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(2.5, 2.5),
            ),
          ),
          child: MoveWindow(
            child: Column(
              children: [
                _logoWidget(),
                _selectorWidget(),
                _pageViewWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoWidget() => SizedBox(
        child: Image(
          width: 220,
          height: 220,
          image: AssetImage('assets/images/logo.png'),
        ),
      );

  Widget _selectorWidget() => Container(
        width: 280,
        height: 50,
        margin: EdgeInsets.only(top: 24.0),
        decoration: BoxDecoration(
          color: CustomTheme.complementaryColor1,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: CustomPaint(
          painter: BubbleIndicatorPainter(pageController: _pageController),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () => _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                  ),
                  child: Text(
                    "Accedi",
                    style: TextStyle(
                        color: signiInColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () => _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                  ),
                  child: Text(
                    "Registrati",
                    style: TextStyle(
                        color: signUpColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _pageViewWidget() => Expanded(
        flex: 1,
        child: PageView(
          onPageChanged: (index) {
            setState(() {
              signiInColor = index == 0 ? Colors.black : Colors.white;
              signUpColor = index == 1 ? Colors.black : Colors.white;
            });
          },
          controller: _pageController,
          children: [
            SignInTab(),
            SignUpTab(),
          ],
        ),
      );
}
