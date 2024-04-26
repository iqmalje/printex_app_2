// Components that will be used throughout the app to make the design consistent through the app

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:printex_app/pages/homepage/howtousepage.dart';
// import 'package:printex_app/pages/settings/settings.dart';

class PrinTEXComponents {
  PreferredSize appBarWithBackButton(String title, BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: const Color(0xFF6F6EFF),
                iconSize: 25,
              ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          backgroundColor: const Color(0xFF6F6EFF),
        ));
  }

  PreferredSize appBar(String title, BuildContext context, String? profpic) {
    if (profpic == null) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      // builder: (context) => const HowToUsePage());
                      builder: (context) => Container());
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 30,
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Switcher().SwitchPage(
                      context,
                      // const SettingsPage());
                      Container());
                },
                child: Ink(
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
            )
          ],
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          backgroundColor: const Color(0xFF6F6EFF),
        ),
      );
    } else {
      return PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Switcher().SwitchPage(
                      context,
                      // const SettingsPage());
                      Container());
                },
                child: Ink(
                  width: 50,
                  height: 50,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(profpic),
                      fit: BoxFit.cover,
                    ),
                    shape: const OvalBorder(),
                  ),
                ),
              ),
            )
          ],
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          backgroundColor: const Color(0xFF6F6EFF),
        ),
      );
    }
  }

  Widget dropdownButtonString(
      List<DropdownMenuItem<String>> items,
      double width,
      double height,
      String val,
      void Function(Object? value) onChange) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              value: val,
              items: items,
              onChanged: onChange,
            ),
          ),
        ),
      ),
    );
  }

  Widget outlinedButton(double width, String label, void Function() onTap,
      {bool isLoading = false, double height = 55}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: Builder(builder: (context) {
              if (!isLoading) {
                return Text(
                  label,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                );
              } else {
                return const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget inputPasswordField(
      double widthSize,
      String hint,
      bool isPasswordHidden,
      void Function() onTap,
      TextEditingController controller,
      {double height = 60}) {
    return Container(
      height: height,
      width: widthSize,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Center(
          child: TextField(
            controller: controller,
            cursorColor: Colors.black,
            obscureText: isPasswordHidden,
            decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Material(
                  borderRadius: BorderRadius.circular(100),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onTap,
                    child: isPasswordHidden
                        ? const Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFFD9D9D9),
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: Color(0xFFD9D9D9),
                          ),
                  ),
                ),
                hintText: hint,
                hintStyle: const TextStyle(
                    color: Color(0xFFD9D9D9), fontFamily: 'Poppins')),
          ),
        ),
      ),
    );
  }

  Widget filledButton(double width, String label, void Function() onTap,
      {double fontsize = 18, double? scale, double heightS = 50}) {
    double height = scale == null
        ? heightS
        : scale < 1
            ? 45
            : 50;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: const Color(0xFF6F6EFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              label,
              textScaleFactor: scale,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: fontsize),
            ),
          ),
        ),
      ),
    );
  }

  Widget greyButton(double width, String label, void Function() onTap,
      {double fontsize = 18, double height = 50}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: fontsize),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(
      double widthSize, String hint, TextEditingController controller,
      {List<TextInputFormatter>? formats,
      TextInputType? inputType,
      IconData? suffixIcon,
      double height = 60,
      void Function(String)? onChanged}) {
    return Container(
      height: height,
      width: widthSize,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Center(
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            onChanged: onChanged,
            inputFormatters: formats,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: suffixIcon == null
                    ? null
                    : Icon(
                        suffixIcon,
                        color: const Color(0xFFD9D9D9),
                      ),
                hintText: hint,
                hintStyle: const TextStyle(
                    color: Color(0xFFD9D9D9), fontFamily: 'Poppins')),
          ),
        ),
      ),
    );
  }
}

//A switcher class, provide useful switching page transition that aligns with phone's OS

class Switcher {
  Future<dynamic> SwitchPage(
      BuildContext context, Widget destinationPage) async {
    if (Platform.isAndroid) {
      return await Navigator.push(
          context, MaterialPageRoute(builder: (context) => destinationPage));
      // PageTransition(
      //     child: destinationPage, type: PageTransitionType.rightToLeft));
    } else {
      return await Navigator.push(
          context, CupertinoPageRoute(builder: (context) => destinationPage));
    }
  }
}

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 1}) {
    final height = MediaQuery.sizeOf(context).height;
    print(height);
    if (height < 700) {
      return 0.8;
    }

    return 1;
  }
}
