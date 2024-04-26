//this page is used for housing three separate pages that can be accessed through navbar

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/homepage/ewalletpage.dart';
import 'package:printex_app_v2/homepage/homepage.dart';
import 'package:printex_app_v2/homepage/printingorder.dart';
import 'package:printex_app_v2/main.dart';

class TempPage extends StatefulWidget {
  int? pageindex;
  TempPage({super.key, this.pageindex});

  @override
  State<TempPage> createState() => _TempPageState(pageindex);
}

class _TempPageState extends State<TempPage> {
  int pageindex = 0;
  final cardController = PageController(viewportFraction: 1, keepPage: true);
  _TempPageState(int? pageindex) {
    if (pageindex == null) {
      this.pageindex = 0;
    } else {
      this.pageindex = pageindex;
    }
  }

  @override
  Widget build(BuildContext context) {
    double scale = ScaleSize.textScaleFactor(context);
    print(scale);

    return Scaffold(
        body: Builder(builder: (context) {
          if (MyApp.needUpdate) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: const Text(
                          'Please update your app!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        content: const Text(
                          'Updating your app ensures maximum security, latest features and reduced bug!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Okay',
                                style: TextStyle(fontFamily: 'Poppins'),
                              )),
                        ]);
                  });
            });
          }

          return Container(
            child: [
              const Homepage(),
              const PrintingOrderPage(),
              const eWalletPage()
            ][pageindex],
          );
        }),
        bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, -4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      setState(() {
                        pageindex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Ink(
                        child: Column(
                          children: [
                            Icon(
                              Icons.home,
                              size: 25,
                              color: pageindex == 0
                                  ? const Color(0xFF6F6EFF)
                                  : Colors.grey,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: pageindex == 0
                                    ? const Color(0xFF6F6EFF)
                                    : Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      setState(() {
                        pageindex = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Ink(
                        child: Column(
                          children: [
                            Icon(
                              Icons.feed,
                              size: 25,
                              color: pageindex == 1
                                  ? const Color(0xFF6F6EFF)
                                  : Colors.grey,
                            ),
                            Text(
                              'Printing',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: pageindex == 1
                                    ? const Color(0xFF6F6EFF)
                                    : Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      setState(() {
                        pageindex = 2;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Ink(
                        child: Column(
                          children: [
                            Icon(
                              Icons.wallet,
                              size: 25,
                              color: pageindex == 2
                                  ? const Color(0xFF6F6EFF)
                                  : Colors.grey,
                            ),
                            Text(
                              'eWallet',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: pageindex == 2
                                    ? const Color(0xFF6F6EFF)
                                    : Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        // Container(
        //   decoration: const BoxDecoration(
        //     boxShadow: [
        //       BoxShadow(
        //         color: Color(0x3F000000),
        //         blurRadius: 4,
        //         offset: Offset(0, -4),
        //         spreadRadius: 0,
        //       )
        //     ],
        //   ),
        //   child: SizedBox(
        //     height: 60,
        //     child: BottomNavigationBar(
        //       currentIndex: pageindex,
        //       onTap: (value) {
        //         setState(() {
        //           pageindex = value;
        //         });
        //       },
        //       items: const [
        //         BottomNavigationBarItem(
        //             icon: Icon(
        //               Icons.home,
        //               size: 25,
        //             ),
        //             label: 'Home'),
        //         BottomNavigationBarItem(
        //             icon: Icon(
        //               Icons.feed,
        //               size: 25,
        //             ),
        //             label: 'Printing'),
        //         BottomNavigationBarItem(
        //             icon: Icon(
        //               Icons.wallet,
        //               size: 25,
        //             ),
        //             label: 'eWallet'),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
