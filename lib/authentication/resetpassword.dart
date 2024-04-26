import 'package:flutter/material.dart';
import 'package:printex_app_v2/backend/authenticationDAO.dart';
import 'package:printex_app_v2/components.dart';

class ResetPasswordPage extends StatefulWidget {
  String email;
  ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ForgotPasswordPageState(email);
}

class _ForgotPasswordPageState extends State<ResetPasswordPage> {
  String email;
  _ForgotPasswordPageState(this.email);
  TextEditingController password = TextEditingController(),
      confirmpassword = TextEditingController();
  bool passwordRevealed = false, confirmPasswordRevealed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF6F6EFF),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 100.0, left: 50, right: 50, bottom: 50),
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
                          'Reset Password',
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
                            'Please enter your new password ',
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
                        PrinTEXComponents().inputPasswordField(
                            MediaQuery.sizeOf(context).width - 50,
                            'Password',
                            !passwordRevealed, () {
                          setState(() {
                            passwordRevealed = !passwordRevealed;
                          });
                        }, password),
                        const SizedBox(
                          height: 20,
                        ),
                        PrinTEXComponents().inputPasswordField(
                            MediaQuery.sizeOf(context).width - 50,
                            'Confirm Password',
                            !confirmPasswordRevealed, () {
                          setState(() {
                            confirmPasswordRevealed = !confirmPasswordRevealed;
                          });
                        }, confirmpassword),
                      ],
                    ),
                    PrinTEXComponents().outlinedButton(
                        MediaQuery.sizeOf(context).width - 50, 'CONFIRM',
                        () async {
                      if (confirmpassword.text != password.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password did not match!')));
                        return;
                      }

                      try {
                        await AuthenticationDAO()
                            .setNewPassword(email, password.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));

                        return;
                      }

                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/signin', (route) => false);
                    })
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
