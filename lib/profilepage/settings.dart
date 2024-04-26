// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printex_app_v2/backend/authenticationDAO.dart';
import 'package:printex_app_v2/components.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController? fullname = TextEditingController(text: 'Iqmal Aizat'),
      mobilenumber,
      email;
  bool editFN = false, editMB = false, editEM = false;
  bool showButton = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents().appBarWithBackButton('Settings', context),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height - 100,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                        future: AuthenticationDAO().getProfileInfo(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          fullname = TextEditingController(
                              text: snapshot.data['fullname']);
                          mobilenumber = TextEditingController(
                              text: snapshot.data['phone']);
                          email = TextEditingController(
                              text: snapshot.data['email']);
                          return Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(1000),
                                onTap: () async {
                                  var result = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);

                                  if (result != null) {
                                    await AuthenticationDAO()
                                        .updateProfilePic(File(result.path));
                                    setState(() {});
                                  }
                                },
                                child: Builder(builder: (context) {
                                  if (snapshot.data!['profilepic'] == null) {
                                    return Ink(
                                      width: 70,
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3F000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.account_circle,
                                        color:
                                            Color.fromARGB(255, 209, 209, 209),
                                        size: 70,
                                      ),
                                    );
                                  } else {
                                    return Ink(
                                      width: 70,
                                      height: 70,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data['profilepic']),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: const OvalBorder(),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x3F000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 80,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Full Name',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.6,
                                              height: 24,
                                              child: TextField(
                                                readOnly: !editFN,
                                                onSubmitted: (value) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Are you sure?',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 0,
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  fullname!
                                                                          .text =
                                                                      value;
                                                                  if (fullname !=
                                                                      null) {
                                                                    await updateDetails(
                                                                        'fn',
                                                                        context,
                                                                        value);
                                                                  }

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Yes',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                  ),
                                                                )),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'No',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                  ),
                                                                )),
                                                          ],
                                                        );
                                                      });
                                                  setState(() {});
                                                },
                                                controller: fullname,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                              ),
                                            )
                                            /*
                                            Text(
                                              snapshot.data!['fullname'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ) */
                                          ]),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              editFN = !editFN;
                                            });

                                            if (!editFN) {
                                              await updateDetails('fn', context,
                                                  fullname!.text);
                                            }
                                          },
                                          child: Text(
                                            editFN ? 'Done' : 'Edit',
                                            style: const TextStyle(
                                              color: Color(0xFF2728FF),
                                              fontSize: 10,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.underline,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 80,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Mobile Number',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.6,
                                              height: 24,
                                              child: TextField(
                                                readOnly: !editMB,
                                                onSubmitted: (value) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Are you sure?',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    mobilenumber!
                                                                            .text =
                                                                        value;
                                                                    if (mobilenumber !=
                                                                        null) {
                                                                      await updateDetails(
                                                                          'mb',
                                                                          context,
                                                                          value);
                                                                    }

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Yes',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                  )),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'No',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                  )),
                                                            ],
                                                          );
                                                        });
                                                      });
                                                  setState(() {});
                                                },
                                                controller: mobilenumber,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: [
                                                  MaskedInputFormatter(
                                                      '000-000 00000')
                                                ],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                              ),
                                            )
                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 80,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Email',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.65,
                                                child: Text(
                                                  snapshot.data!['email'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12),
                                                ))
                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }),
                    const SizedBox(height: 20),
                    PrinTEXComponents().greyButton(
                        MediaQuery.sizeOf(context).width * 0.8,
                        'Delete Account', () async {
                      showButton = false;
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController password =
                              TextEditingController();

                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              actionsAlignment: MainAxisAlignment.center,
                              title: const Text(
                                'Please re-enter your email to confirm account deletion',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 17),
                              ),
                              content: PrinTEXComponents().inputField(
                                  MediaQuery.sizeOf(context).width - 50,
                                  'Email',
                                  password, onChanged: (value) {
                                print(value);
                                print(email!.text);
                                if (value == email!.text) {
                                  setState(() {
                                    showButton = true;
                                  });
                                } else {
                                  setState(() {
                                    showButton = false;
                                  });
                                }
                              }),
                              actions: [
                                Builder(builder: (context) {
                                  if (showButton) {
                                    return ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        onPressed: () async {
                                          await AuthenticationDAO().deleteAccount();

                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/signin', (route) => false);
                                        },
                                        child: const Text(
                                          'Delete account',
                                          style: TextStyle(color: Colors.white),
                                        ));
                                  } else {
                                    return Container();
                                  }
                                })
                              ],
                            );
                          });
                        },
                      );
                    }),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: PrinTEXComponents().filledButton(
                          MediaQuery.sizeOf(context).width * 0.8, 'Log Out',
                          () async {
                        await AuthenticationDAO().supabase.auth.signOut();

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/signin', (route) => false);
                      }),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateDetails(
      String type, BuildContext context, String value) async {
    bool isUpdate = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )),
            ],
          );
        });

    if (!isUpdate) return;
    switch (type) {
      case 'fn':
        print(value);
        await AuthenticationDAO().updateFullName(value);

        setState(() {});
        break;

      case 'mb':
        await AuthenticationDAO().updatePhone(mobilenumber!.text);
        setState(() {});
        break;

      case 'em':
        await AuthenticationDAO().updateEmail(email!.text);
        setState(() {});
        break;

      default:
    }
  }
}
