import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_to_pdf/export_delegate.dart';
import 'package:flutter_to_pdf/export_frame.dart';
import 'package:intl/intl.dart';
import 'package:printex_app_v2/backend/apmDAO.dart';
import 'package:printex_app_v2/components.dart';

class ReceiptPage extends StatefulWidget {
  Map settings;
  double cost;
  String orderid;
  Map fileDetails;
  String status;
  DateTime date;
  Map<String, dynamic> apmDetails;
  ReceiptPage(
      {super.key,
      required this.settings,
      required this.cost,
      required this.orderid,
      required this.status,
      required this.fileDetails,
      required this.apmDetails,
      required this.date});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState(
      settings, fileDetails, status, cost, orderid, apmDetails, date);
}

class _ReceiptPageState extends State<ReceiptPage> {
  Map settings;
  double cost;
  String orderid;
  Map fileDetails;
  String status;
  DateTime date;
  Map<dynamic, dynamic> apmDetails;

  _ReceiptPageState(this.settings, this.fileDetails, this.status, this.cost,
      this.orderid, this.apmDetails, this.date);
  final ExportDelegate exportDelegate = ExportDelegate(
      ttfFonts: {'Poppins': 'assets/fonts/Poppins/Poppins-Regular.ttf'});
  @override
  Widget build(BuildContext context) {
    print('settings = $settings');
    print('cost = $cost');
    print('orderid = $orderid');
    print('fileDetails = $fileDetails');
    print('status = $status');

    return Scaffold(
      appBar: PrinTEXComponents().appBarWithBackButton('Receipt', context),
      backgroundColor: const Color(0xFFEDEDED),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: 3000,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                    minWidth: MediaQuery.sizeOf(context).width * 0.8,
                  ),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ExportFrame(
                    frameId: 'receipt',
                    exportDelegate: exportDelegate,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 10, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Order Details',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          buildTitleAndSubtitle(title: 'Date', subtitles: [
                            DateFormat('d MMMM yyyy, hh:mm a').format(date)
                          ]),
                          buildTitleAndSubtitle(
                              title: 'PrinTEX Location',
                              subtitles: [apmDetails['printername']]),
                          FutureBuilder(
                              future: ApmDAO().getAPMCost(apmDetails['apmid']),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return const CircularProgressIndicator();

                                print(snapshot.data!);
                                return buildTitleAndSubtitle(
                                    title: 'PrinTEX Pricing Rate',
                                    subtitles: [
                                      '${'A4 Single Sided B&W'.padRight(25, ' ')} : RM ${(snapshot.data!['black_white_single'] as double).toStringAsFixed(2)}/page',
                                      '${'A4 Both Sided B&W'.padRight(25, ' ')} : RM ${(snapshot.data!['black_white_both'] as double).toStringAsFixed(2)}/page',
                                      '${'A4 Single Sided Color'.padRight(26, ' ')} : RM ${(snapshot.data!['color_single'] as double).toStringAsFixed(2)}/page',
                                      '${'A4 Both Sided Color'.padRight(26, ' ')} : RM ${(snapshot.data!['color_both'] as double).toStringAsFixed(2)}/page',
                                    ]);
                              }),
                          buildTitleAndSubtitle(
                              title: 'File Name',
                              subtitles: [fileDetails['filename']]),
                          buildTitleAndSubtitle(
                              title: 'Printing Color',
                              subtitles: [settings['color']]),
                          buildTitleAndSubtitle(
                              title: 'Printing Side',
                              subtitles: [settings['side']]),
                          buildTitleAndSubtitle(
                              title: 'Page Per Sheet',
                              subtitles: [settings['pagepersheet']]),
                          buildTitleAndSubtitle(
                              title: 'Copies',
                              subtitles: [settings['copies'].toString()]),
                          buildTitleAndSubtitle(
                              title: 'Total Pages',
                              subtitles: [fileDetails['pagecount'].toString()]),
                          buildTitleAndSubtitle(
                              title: 'Platform Fee', subtitles: ['RM 0.10']),
                          buildTitleAndSubtitle(
                              title: 'Total Cost',
                              subtitles: ['RM ${cost.toStringAsFixed(2)}']),
                          buildTitleAndSubtitle(
                              title: 'Payment Methods',
                              subtitles: ['Online Banking']),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PrinTEXComponents().filledButton(
                  MediaQuery.sizeOf(context).width * 0.8, 'Download Receipt',
                  () async {
                final pdf = await exportDelegate.exportToPdfDocument('receipt');
                Uint8List data = await pdf.save();

                await DocumentFileSavePlus()
                    .saveFile(data, 'RECEIPT_$orderid.pdf', 'application/pdf');

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'File has successfully downloaded into your device!')));
              }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleAndSubtitle(
      {required String title, required List<String> subtitles}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF636363)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              subtitles.length,
              (index) => Text(
                    subtitles[index],
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black),
                  )),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var smallLineLength = size.width / 40;
    const smallLineHeight = 10;
    var path = Path();

    path.lineTo(0, size.height);
    for (int i = 1; i <= 40; i++) {
      if (i % 2 == 0) {
        path.lineTo(smallLineLength * i, size.height);
      } else {
        path.lineTo(smallLineLength * i, size.height - smallLineHeight);
      }
    }
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
