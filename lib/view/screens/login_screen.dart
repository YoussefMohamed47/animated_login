import 'package:animatedlogin/utils/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtBoard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHands_up;
  late RiveAnimationController controllerhands_down;
  late RiveAnimationController controllersuccess;
  late RiveAnimationController controllerfail;
  late RiveAnimationController controllerLook_down_right;
  late RiveAnimationController controllerLook_down_left;
  final _formKey = GlobalKey<FormState>();
  String testEmail = 'jomohamed87@gmail.com';
  String testPassword = '123456';
  final passwordFocus = FocusNode();
  bool isLookingLeft = false;
  bool isLookingRight = false;
  void removeAllController() {
    riveArtBoard!.artboard.removeController(controllerIdle);
    riveArtBoard!.artboard.removeController(controllerHands_up);
    riveArtBoard!.artboard.removeController(controllerhands_down);
    riveArtBoard!.artboard.removeController(controllersuccess);
    riveArtBoard!.artboard.removeController(controllerfail);
    riveArtBoard!.artboard.removeController(controllerLook_down_right);
    riveArtBoard!.artboard.removeController(controllerLook_down_left);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerIdle);
    debugPrint('Idleeee');
  }

  void addHandsUpController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerHands_up);
    debugPrint('controllerHands_up');
  }

  void addHandsDownController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerhands_down);
    debugPrint('controllerhands_down');
  }

  void addSuccessController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllersuccess);
    debugPrint('controllersuccess');
  }

  void addFailController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerfail);
    debugPrint('controllerfail');
  }

  void addLookDownRightController() {
    removeAllController();
    isLookingRight = true;
    riveArtBoard!.artboard.addController(controllerLook_down_right);
    debugPrint('controllerLook_down_right');
  }

  void addLookLeftController() {
    removeAllController();
    isLookingLeft = true;
    riveArtBoard!.artboard.addController(controllerLook_down_left);
    debugPrint('controllerLook_down_left');
  }

  void checkForPasswordFocusNode() {
    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus) {
        addHandsUpController();
      } else {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHands_up = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerhands_down = SimpleAnimation(AnimationEnum.hands_down.name);
    controllersuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerfail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLook_down_right =
        SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLook_down_left =
        SimpleAnimation(AnimationEnum.Look_down_left.name);
    rootBundle.load('assets/animation/login_animation.riv').then((data) {
      final file = RiveFile.import(data);
      final mainArtBoard = file.mainArtboard;
      mainArtBoard.addController(controllerIdle);
      setState(() {
        print('Rive $riveArtBoard');
        riveArtBoard = mainArtBoard;
        print('Rive after $riveArtBoard');
      });
    });
    checkForPasswordFocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Login Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: riveArtBoard == null
                  ? SizedBox.shrink()
                  : Rive(
                      artboard: riveArtBoard!,
                    ),
            ),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty &&
                          value.length < 16 &&
                          !isLookingLeft) {
                        addLookLeftController();
                      } else if (value.isNotEmpty &&
                          value.length > 16 &&
                          !isLookingRight) {
                        addLookDownRightController();
                      }
                    },
                    validator: (value) =>
                        value != testEmail ? 'Wrong Email' : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    obscureText: true,
                    focusNode: passwordFocus,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) =>
                        value != testPassword ? 'Wrong Password' : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        passwordFocus.unfocus();
                        //sssss
                        Future.delayed(
                          Duration(seconds: 1),
                          () {
                            if (_formKey.currentState!.validate()) {
                              addSuccessController();
                            } else {
                              addFailController();
                            }
                          },
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
