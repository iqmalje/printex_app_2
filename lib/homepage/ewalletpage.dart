import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:printex_app_v2/backend/walletDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/wallet/reloadpage.dart';

class eWalletPage extends StatefulWidget {
  const eWalletPage({super.key});

  @override
  State<eWalletPage> createState() => _eWalletPageState();
}

class _eWalletPageState extends State<eWalletPage> {
  List<dynamic> transactions = [];
  String? profpic;

  @override
  void initState() {
    // SupabaseB().getProfilePic().then((value) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     setState(() {
    //       profpic = value;
    //     });
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents().appBar('eWallet', context, profpic),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 140,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFDDEFFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Balance',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'RM',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  FutureBuilder<double>(
                                      future: WalletDAO().getWalletDetails(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          print(snapshot.data!);
                                          return Text(
                                            snapshot.data!.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 50),
                                          );
                                        }
                                      }),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: FloatingActionButton(
                            backgroundColor: const Color(0xFF2728FF),
                            shape: const CircleBorder(),
                            onPressed: () async {
                              await Switcher().SwitchPage(
                                  context, const ReloadWalletPage());

                              setState(() {});
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.sizeOf(context).width * 0.1,
                      right: MediaQuery.sizeOf(context).width * 0.1,
                      top: 40),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction History',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text('Last 60 days')
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: WalletDAO().getTransactions(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                              width: 50,
                              height: 50,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                        transactions = snapshot.data!;
                        if (transactions.isEmpty) {
                          return SvgPicture.asset(
                            'assets/images/emptytransaction.svg',
                            semanticsLabel: 'Empty Transaction',
                            height: 310,
                            width: 280,
                          );
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.sizeOf(context).width *
                                    0.1 *
                                    0.5),
                            shrinkWrap: true,
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              if (transactions.elementAt(index)['type'] ==
                                      'RELOAD' &&
                                  transactions.elementAt(index)['status'] ==
                                      'SUCCESSFUL') {
                                return buildReloadTransaction(
                                    context,
                                    double.parse(transactions
                                        .elementAt(index)['amount']
                                        .toString()),
                                    transactions.elementAt(index)['date']);
                              } else if (transactions
                                      .elementAt(index)['type'] ==
                                  'ORDER') {
                                return buildOrderTransaction(
                                    context,
                                    double.parse(transactions
                                        .elementAt(index)['amount']
                                        .toString()),
                                    transactions.elementAt(index)['date'],
                                    transactions.elementAt(index)['filename']);
                              } else {
                                return Container();
                              }
                            },
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildReloadTransaction(
      BuildContext context, double amount, DateTime date) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: 60,
        decoration: ShapeDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Reload Wallet',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  Text(
                    '${date.day} ${months[date.month - 1]}, ${DateFormat('hh:mm a').format(date)}',
                    //'9 Apr, 13:53',
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
              Text(
                '+RM${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF2728FF),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildOrderTransaction(
      BuildContext context, double amount, DateTime date, String filename) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: 60,
        decoration: ShapeDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      filename,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    Text(
                      '${date.day} ${months[date.month - 1]}, ${DateFormat('hh:mm a').format(date)}',
                      //'9 Apr, 13:53',
                      style: const TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '-RM${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
