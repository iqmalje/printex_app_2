import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:printex_app_v2/authentication/emailverification.dart';
import 'package:printex_app_v2/backend/authenticationDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordHidden = true,
      isConfirmPasswordHidden = true,
      checkboxTicked = false,
      isLoading = false;

  TextEditingController fullname = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController(),
      password = TextEditingController(),
      confirmpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF6F6EFF),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 45.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          PrinTEXComponents().inputField(
                            MediaQuery.sizeOf(context).width * 0.8,
                            'Full Name',
                            fullname,
                            height: 50,
                          ),
                          PrinTEXComponents().inputField(
                              MediaQuery.sizeOf(context).width * 0.8,
                              'Email',
                              email,
                              suffixIcon: Icons.mail,
                              height: 50,
                              formats: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ]),
                          PrinTEXComponents().inputField(
                            MediaQuery.sizeOf(context).width * 0.8,
                            'Mobile Number',
                            phone,
                            height: 50,
                            formats: [
                              FilteringTextInputFormatter.digitsOnly,
                              MaskedInputFormatter('###-### #####')
                            ],
                            inputType: TextInputType.phone,
                            suffixIcon: Icons.phone,
                            onChanged: (value) {
                              phone.text = value;
                              phone.selection = TextSelection.fromPosition(
                                  TextPosition(offset: value.length));
                            },
                          ),
                          PrinTEXComponents().inputPasswordField(
                              MediaQuery.sizeOf(context).width * 0.8,
                              'Password',
                              isPasswordHidden, () {
                            setState(
                              () {
                                isPasswordHidden = !isPasswordHidden;
                              },
                            );
                          }, password, height: 50),
                          PrinTEXComponents().inputPasswordField(
                              MediaQuery.sizeOf(context).width * 0.8,
                              'Confirm Password',
                              isConfirmPasswordHidden, () {
                            setState(() {
                              isConfirmPasswordHidden =
                                  !isConfirmPasswordHidden;
                            });
                          }, confirmpassword, height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  value: checkboxTicked,
                                  onChanged: (val) {
                                    setState(() {
                                      checkboxTicked = val!;
                                    });
                                  },
                                ),
                              ),
                              const Text(
                                ' I have agree with ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'terms & conditions',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: PrinTEXComponents().outlinedButton(
                            MediaQuery.sizeOf(context).width * 0.8, 'SIGN UP',
                            () async {
                          if (isLoading) return;
                          setState(() {
                            isLoading = true;
                          });

                          bool isEmailValid =
                              EmailValidator.validate(email.text);
                          if (!isEmailValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please enter a valid email')));

                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          if (password.text != confirmpassword.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Your password did not match!')));
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          if (!checkboxTicked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree with our terms and conditions!')));
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          try {
                            await AuthenticationDAO().signUp(fullname.text, email.text,
                                phone.text, password.text);
                          } on PostgrestException catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('E-mail already existed!')));
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          } on AuthException {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Password should be at least 6 characters!')));
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          //pushes to email verification

                          Switcher().SwitchPage(
                              context,
                              EmailVerificationPage(
                                email: email.text,
                              ));

                          setState(() {
                            isLoading = false;
                          });
                        }, isLoading: isLoading),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
