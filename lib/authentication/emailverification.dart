import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printex_app_v2/authentication/congrats.dart';
import 'package:printex_app_v2/backend/authenticationDAO.dart';
import 'package:printex_app_v2/components.dart';

class EmailVerificationPage extends StatefulWidget {
  String email;
  EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() =>
      _PhoneVerificationPageState(email);
}

class _PhoneVerificationPageState extends State<EmailVerificationPage> {
  Timer? timer;
  int _start = 330;

  bool isTimerCounting = true;
  String email;
  _PhoneVerificationPageState(this.email);
  //6 for each character
  List<TextEditingController> OTP = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  bool isLoading = false;
  @override
  void initState() {
    if (mounted) {
      isTimerCounting = true;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_start == 0) {
          setState(() {
            this.timer!.cancel();
            isTimerCounting = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var node = FocusScope.of(context);
    var scale = ScaleSize.textScaleFactor(context);
    return Scaffold(
      backgroundColor: const Color(0xFF6F6EFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('assets/images/email_verification_logo.png'),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Verify Your Email',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'A 6-digit code has been sent to',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                email,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Change Email',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              const SizedBox(
                height: 27,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 43,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x143D6886),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x193D6886),
                            blurRadius: 9,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          child: TextField(
                            controller: OTP[0],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x143D6886),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x193D6886),
                            blurRadius: 9,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          child: TextField(
                            controller: OTP[1],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x143D6886),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x193D6886),
                            blurRadius: 9,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          child: TextField(
                            controller: OTP[2],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x143D6886),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x193D6886),
                            blurRadius: 9,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          child: TextField(
                            controller: OTP[3],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x143D6886),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x193D6886),
                            blurRadius: 9,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          child: TextField(
                            controller: OTP[4],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x143D6886),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x193D6886),
                            blurRadius: 9,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          child: TextField(
                            controller: OTP[5],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    const Text(
                      'The OTP will be expired in ',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      formattedTime(timeInSecond: _start),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  children: [
                    const Text(
                      'Didn\'t receive the code? ',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!isTimerCounting) {
                          await AuthenticationDAO().resendOTP(email);
                          //restart the timer
                          setState(() {
                            _start = 330;
                            isTimerCounting = true;
                          });

                          timer = Timer.periodic(const Duration(seconds: 1),
                              (timer) {
                            if (_start == 0) {
                              setState(() {
                                this.timer!.cancel();
                                isTimerCounting = false;
                              });
                            } else {
                              setState(() {
                                _start--;
                              });
                            }
                          });
                        }
                      },
                      child: const Text(
                        'Resend',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              PrinTEXComponents().outlinedButton(
                  MediaQuery.sizeOf(context).width * 0.8 * 0.8, 'Verify',
                  () async {
                if (isLoading) return;
                setState(() {
                  isLoading = true;
                });
                //build string
                String inputtedOTP = '';

                for (var controller in OTP) {
                  inputtedOTP += controller.text;
                }

                bool result =
                    await AuthenticationDAO().verifyOTP(email, inputtedOTP);
                if (!result) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Token is invalid or expired, please try again')));
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  Switcher().SwitchPage(context, const CongratsPage());
                }
                setState(() {
                  isLoading = false;
                });
              }, isLoading: isLoading)
            ]),
          ),
        ),
      ),
    );
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }
}
