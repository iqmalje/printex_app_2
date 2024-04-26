// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printex_app_v2/components.dart';

class CongratsPage extends StatefulWidget {
  const CongratsPage({super.key});

  @override
  State<CongratsPage> createState() => _CongratsPageState();
}

class _CongratsPageState extends State<CongratsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Congrats!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      child: const Text(
                        'You have successfully created an account with the PrinTEX App. Please click \'Proceed\' to sign in to your account.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    SvgPicture.asset(
                      'assets/images/congrats.svg',
                      semanticsLabel: 'Congrats',
                      height: 310,
                      width: 280,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: PrinTEXComponents().outlinedButton(
                    MediaQuery.sizeOf(context).width * 0.8, 'PROCEED',
                    () async {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                }),
              )
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF6F6EFF),
    );
  }
}
