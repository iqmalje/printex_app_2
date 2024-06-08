import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printex_app_v2/backend/authenticationDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/authentication/forgotpassword.dart';
import 'package:printex_app_v2/authentication/signuppage.dart';
import 'package:printex_app_v2/authentication/emailverification.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isPasswordHidden = true, isLoading = false;
  TextEditingController email = TextEditingController(),
      password = TextEditingController();

  double containerheight = 0;

  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    super.initState();

    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((event) {
      setState(() {
        _sharedFiles.clear();

        _sharedFiles.addAll(event);
      });

      print(_sharedFiles.map((e) => e.toMap()));
    }, onError: (err) {
      print("error = $err");
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        print(_sharedFiles.map((f) => f.toMap()));

        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.sizeOf(context).height);
    double screenheight = MediaQuery.sizeOf(context).height;
    containerheight = screenheight > 800
        ? MediaQuery.sizeOf(context).height * 0.7
        : screenheight < 700
            ? MediaQuery.sizeOf(context).height * 0.8
            : MediaQuery.sizeOf(context).height * 0.75;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/printex_text.svg',
                          semanticsLabel: 'PrinTEX',
                          height: 60,
                          // width: 280,
                        ),
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    if (_sharedFiles.isEmpty) return Container();
                    return Text(_sharedFiles.first.toMap().toString());
                  }),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF6F6EFF),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45))),
                    width: MediaQuery.sizeOf(context).width,
                    height: containerheight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 45.0, top: 45, right: 45, bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Welcome to PrinTEX',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20)),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Log In',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40)),
                              const SizedBox(
                                height: 35,
                              ),
                              PrinTEXComponents().inputField(
                                  MediaQuery.sizeOf(context).width * 0.8,
                                  'Email',
                                  email,
                                  formats: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s'))
                                  ],
                                  suffixIcon: Icons.mail),
                              const SizedBox(
                                height: 25,
                              ),
                              PrinTEXComponents().inputPasswordField(
                                  MediaQuery.sizeOf(context).width * 0.8,
                                  'Password',
                                  isPasswordHidden, () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              }, password),
                              const SizedBox(
                                height: 18,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Switcher().SwitchPage(
                                        context, const ForgotPasswordPage());
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              PrinTEXComponents().outlinedButton(
                                  MediaQuery.sizeOf(context).width * 0.8,
                                  'SIGN IN', () async {
                                if (isLoading) return;

                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  // ignore: unused_local_variable
                                  String result = await AuthenticationDAO()
                                      .signIn(email.text, password.text);

                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/home', (route) => false);
                                } on EmailNotVerified {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text('Please verify your email first'),
                                  ));
                                  AuthenticationDAO().supabase.auth.resend(
                                      type: OtpType.signup, email: email.text);
                                  Switcher().SwitchPage(context,
                                      EmailVerificationPage(email: email.text));
                                  setState(() {
                                    isLoading = false;
                                  });
                                } on InvalidLoginCredentials {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Invalid login credentials'),
                                  ));
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }, isLoading: isLoading),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don\'t have an account?',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Switcher().SwitchPage(
                                          context, const SignUpPage());
                                    },
                                    child: const Text(
                                      ' SIGN UP',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
