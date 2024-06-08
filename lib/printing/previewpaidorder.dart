// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printex_app_v2/backend/apmDAO.dart';
import 'package:printex_app_v2/backend/orderDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/navigator/navigator.dart';
import 'package:printex_app_v2/printing/qrpage.dart';
import 'package:printex_app_v2/printing/receiptpage.dart';
import 'package:printex_app_v2/printing/viewdetails.dart';

class PreviewPaidOrderPage extends StatefulWidget {
  Map settings;
  double cost;
  String orderid;
  Map fileDetails;
  String status;
  String? apmId;
  DateTime date;
  PreviewPaidOrderPage(
      {super.key,
      required this.settings,
      required this.cost,
      required this.orderid,
      required this.status,
      required this.fileDetails,
      required this.date,
      this.apmId});

  @override
  State<PreviewPaidOrderPage> createState() => _PreviewPaidOrderPageState(
      settings, fileDetails, status, cost, orderid, date, apmId);
}

class _PreviewPaidOrderPageState extends State<PreviewPaidOrderPage> {
  Map settings;
  double cost;
  String orderid;
  Map fileDetails;
  String status;
  String? apmId;
  DateTime date;

  _PreviewPaidOrderPageState(this.settings, this.fileDetails, this.status,
      this.cost, this.orderid, this.date, this.apmId);
  Map<String, dynamic>? apmDetails;
  @override
  Widget build(BuildContext context) {
    print("orderi = $orderid");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/printingpage', (route) => false);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: const Color(0xFF6F6EFF),
                iconSize: 25,
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 40.0),
                child: Text(
                  'Preview Order',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6F6EFF),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: (MediaQuery.sizeOf(context).width * 0.8) / 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: FutureBuilder<dynamic>(
                            future: OrderDAO()
                                .getCoverImageUrl(fileDetails['fileid']),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Image.network(snapshot.data!);
                            })),
                    Builder(builder: (context) {
                      if (fileDetails['pagecount'] == 1) return Container();
                      return Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Switcher().SwitchPage(
                                    context,
                                    ViewDetailsPage(
                                        settings: settings,
                                        fileDetails: fileDetails));
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: OvalBorder(),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Image.asset(
                                    'assets/images/bursts.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Builder(builder: (context) {
                print('APMID = $apmId');
                if (apmId != null) {
                  return FutureBuilder(
                      future: ApmDAO().getAPMDetails(apmId!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        print(snapshot.data);

                        apmDetails = snapshot.data! as Map<String, dynamic>;
                        return Container(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                      color: Colors.black.withOpacity(0.25))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/printex_marker.svg'),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!['printername'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${snapshot.data!['apmaddresses']['city']}, ${snapshot.data!['apmaddresses']['state']}',
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      });
                } else {
                  return Container();
                }
              }),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: 180,
                decoration: ShapeDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shadows: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 211, 211, 211),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                        spreadRadius: 1)
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileDetails['filename'],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Printing color: ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF626262)),
                          ),
                          Text(
                            settings['color'] == 'Black & White'
                                ? 'Black & White'
                                : 'Color',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Printing side: ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF626262)),
                          ),
                          Text(
                            settings['side'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Page per sheet: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF626262)),
                              ),
                              Text(
                                settings['pagepersheet'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Copies: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF626262)),
                              ),
                              Text(
                                'x ${settings['copies']}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Total pages: ${(settings['pagecount'] / int.parse(settings['pagepersheet'][0])).ceil()}',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF626262)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Total cost:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(' RM ${cost.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF2728FF),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Platform fee of RM0.10 is included',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Builder(builder: (context) {
                  if (status == 'DONE') {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrinTEXComponents()
                            .filledButton(170, 'Generate receipt', () async {
                          Switcher().SwitchPage(
                              context,
                              ReceiptPage(
                                settings: settings,
                                fileDetails: fileDetails,
                                status: status,
                                cost: cost,
                                orderid: orderid,
                                apmDetails: apmDetails!,
                                date: date,
                              ));
                        }, fontsize: 17),
                        const SizedBox(
                          width: 20,
                        ),
                        PrinTEXComponents().greyButton(150, 'Delete file',
                            () async {
                          bool? isDeleted = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  title: const Text(
                                    'Are you sure you want to delete this file?',
                                    style: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 17),
                                  ),
                                  actions: [
                                    PrinTEXComponents()
                                        .greyButton(100, 'Cancel', () {
                                      Navigator.of(context).pop();
                                    }, fontsize: 15, height: 40),
                                    PrinTEXComponents()
                                        .filledButton(100, 'Confirm', () async {
                                      await OrderDAO().deleteOrderLive(
                                          orderid, fileDetails['fileid']);

                                      Navigator.of(context).pop(true);
                                    }, fontsize: 15, heightS: 40),
                                  ],
                                );
                              });
                          isDeleted ??= false;
                          if (isDeleted) Navigator.of(context).pop();
                        }, fontsize: 17),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrinTEXComponents().greyButton(150, 'Delete file',
                          () async {
                        bool? isDeleted = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                title: const Text(
                                  'Are you sure you want to delete this file?',
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 17),
                                ),
                                actions: [
                                  PrinTEXComponents().greyButton(100, 'Cancel',
                                      () {
                                    Navigator.of(context).pop();
                                  }, fontsize: 15, height: 40),
                                  PrinTEXComponents()
                                      .filledButton(100, 'Confirm', () async {
                                    await OrderDAO().deleteOrderLive(
                                        orderid, fileDetails['fileid']);

                                    Navigator.of(context).pop(true);
                                  }, fontsize: 15, heightS: 40),
                                ],
                              );
                            });
                        isDeleted ??= false;
                        if (isDeleted) Navigator.of(context).pop();
                      }, fontsize: 16),
                      const SizedBox(
                        width: 30,
                      ),
                      PrinTEXComponents().filledButton(150, 'Print now', () {
                        Switcher().SwitchPage(
                            context,
                            QRPage(
                                filename: fileDetails['filename'],
                                totalpage: (settings['pagecount'] /
                                        int.parse(settings['pagepersheet'][0]))
                                    .ceil(),
                                cost: cost,
                                orderid: orderid));
                      }),
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
