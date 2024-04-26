// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printex_app_v2/authentication/resetpassword.dart';
import 'package:printex_app_v2/backend/authenticationDAO.dart';
import 'package:printex_app_v2/components.dart';

class ResetPasswordConfirmationPage extends StatefulWidget {
  String email;
  ResetPasswordConfirmationPage({super.key, required this.email});

  @override
  State<ResetPasswordConfirmationPage> createState() =>
      _PhoneVerificationPageState(email);
}

class _PhoneVerificationPageState extends State<ResetPasswordConfirmationPage> {
  //6 for each character
  List<TextEditingController> OTP = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  int _start = 330;
  Timer? timer;

  String email;

  _PhoneVerificationPageState(this.email);

  @override
  void initState() {
    if (mounted) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_start == 0) {
          setState(() {
            this.timer!.cancel();
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/lock.png',
                  width: scale < 1 ? 40 : 60,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Verify Reset Password Token',
              textScaleFactor: ScaleSize.textScaleFactor(context),
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'A 6-digit code has been sent to',
              textScaleFactor: ScaleSize.textScaleFactor(context),
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              email,
              textScaleFactor: ScaleSize.textScaleFactor(context),
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.only(
                left: 40,
              ),
              child: Row(
                children: [
                  Text(
                    'The OTP will be expired in ',
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formattedTime(timeInSecond: _start),
                    textScaleFactor: ScaleSize.textScaleFactor(context),
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
                  Text(
                    'Didn\'t receive the code? ',
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (timer!.isActive) return;
                      await AuthenticationDAO().resetPassword(email);
                      _start = 330;
                      timer =
                          Timer.periodic(const Duration(seconds: 1), (timer) {
                        if (_start == 0) {
                          setState(() {
                            this.timer!.cancel();
                          });
                        } else {
                          setState(() {
                            _start--;
                          });
                        }
                      });

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('OTP has been resent!')));
                    },
                    child: Text(
                      'Resend',
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            PrinTEXComponents().outlinedButton(
                MediaQuery.sizeOf(context).width * 0.8 * 0.8, 'Verify',
                () async {
              String OTP = '';

              for (var element in this.OTP) {
                OTP += element.text;
              }
              print(OTP);
              bool verified = await AuthenticationDAO()
                  .confirmResetPasswordToken(email, OTP);

              if (!verified) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invalid OTP, please try again')));
                return;
              }
              Switcher().SwitchPage(context, ResetPasswordPage(email: email));
            }),
            const SizedBox(
              height: 5,
            )
          ]),
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
