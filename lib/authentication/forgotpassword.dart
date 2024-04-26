import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printex_app_v2/authentication/resetpasswordconfirmation.dart';
import 'package:printex_app_v2/backend/authenticationDAO.dart';
import 'package:printex_app_v2/components.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6F6EFF),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 100.0, left: 50, right: 50, bottom: 50),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height - 150,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Forgot \nPassword?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: 300,
                        child: Text(
                          'Please enter your email to reset password! ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      PrinTEXComponents().inputField(
                          MediaQuery.sizeOf(context).width - 50, 'Email', email,
                          formats: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          suffixIcon: Icons.email),
                    ],
                  ),
                  PrinTEXComponents().outlinedButton(
                      MediaQuery.sizeOf(context).width - 50, 'CONFIRM',
                      () async {
                    if (isLoading) return;

                    setState(() {
                      isLoading = true;
                    });

                    await AuthenticationDAO().resetPassword(email.text);

                    setState(() {
                      isLoading = false;
                    });
                    Switcher().SwitchPage(
                        context,
                        ResetPasswordConfirmationPage(
                          email: email.text,
                        ));
                  }, isLoading: isLoading)
                ]),
          ),
        ),
      ),
    );
  }
}

