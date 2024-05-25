// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:path/path.dart';
import 'package:printex_app_v2/backend/orderDAO.dart';
import 'package:printex_app_v2/backend/walletDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/printing/previewpaidorder.dart';
import 'package:printex_app_v2/printing/qrpage.dart';
import 'package:screenshot/screenshot.dart';

class PreviewOrder extends StatefulWidget {
  Map settings;
  File? file;
  Map? filedetails;
  double cost;
  String? orderid;
  dynamic printerItem;
  Map<String, dynamic> costs;
  DateTime date;

  List<Uint8List> selectedPageBytes;
  PreviewOrder(
      {super.key,
      required this.settings,
      this.file,
      this.filedetails,
      required this.cost,
      required this.selectedPageBytes,
      this.orderid,
      required this.printerItem,
      required this.costs,
      required this.date});

  @override
  State<PreviewOrder> createState() => _PreviewOrderState(settings, file,
      filedetails, cost, selectedPageBytes, orderid, printerItem, costs, date);
}

class _PreviewOrderState extends State<PreviewOrder> {
  Map settings;
  double cost;
  String? orderid;
  Map? fileDetails;
  File? file;
  bool previewMode = false;
  bool uploaded = false;
  bool isUploading = false;
  List<Uint8List> selectedPageBytes;
  dynamic printerItem;
  DateTime date;
  Map<String, dynamic> costs;

  Uint8List? coverBytes;
  _PreviewOrderState(this.settings, this.file, this.fileDetails, this.cost,
      this.selectedPageBytes, this.orderid, this.printerItem, this.costs, this.date);

  @override
  void initState() {
    previewMode = fileDetails == null ? false : true;
    super.initState();
  }

  bool isColor = false;
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    print("SETTINGS = $settings");

    isColor = settings['color'] == 'Black & White' ? false : true;
    return WillPopScope(
      onWillPop: () {
        print(previewMode);
        return Future.value(false);
        /*
        if (previewMode) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/printingpage', (route) => false);
          return Future.value(false);
        } else {
          return Future.value(true);
        }*/
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (previewMode) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/printingpage', (route) => false);
                    }
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
                  height: (MediaQuery.sizeOf(context).width * 0.8) * 1.41,
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
                  child: FutureBuilder(
                      future: extension(file!.path).toLowerCase() == '.pdf'
                          ? getFirstImageOfPDF(file!)
                          : getFirstImageOfPNG(file!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return buildPageContent(context, snapshot);
                        }
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
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
                          SvgPicture.asset('assets/images/printex_marker.svg'),
                          const SizedBox(
                            width: 13,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  printerItem['printername'],
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
                                  '${printerItem['city']}, ${printerItem['state']}',
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
                    )),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/images/dollar_logo.svg'),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Check the PrinTEX pricing? ',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 40.0,
                                          bottom: 40,
                                          right: 20,
                                          left: 20),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                        height: 280,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF9F9F9),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 2,
                                                        offset:
                                                            const Offset(0, 2),
                                                        color: Colors.black
                                                            .withOpacity(0.25))
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                      printerItem['pictureurl'],
                                                      width: 60,
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            printerItem[
                                                                'printername'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16),
                                                          ),
                                                          Text(
                                                            printerItem[
                                                                    'city'] +
                                                                ", " +
                                                                printerItem[
                                                                    'state'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xFF636363),
                                                                fontSize: 13),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF9F9F9),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 2,
                                                        offset:
                                                            const Offset(0, 2),
                                                        color: Colors.black
                                                            .withOpacity(0.25))
                                                  ]),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0,
                                                          left: 10,
                                                          top: 20,
                                                          bottom: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/dollar_logo.svg',
                                                            height: 22,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Text(
                                                            'PrinTEX Pricing Rate',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 17),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/images/single_bw.svg'),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'A4 Single Sided B&w    :   RM${costs['black_white_single']!.toStringAsFixed(2)}/page',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/images/multi-bw.svg'),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'A4 Both Sided B&W      :   RM${costs['black_white_both']!.toStringAsFixed(2)}/page',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/images/single-color.svg'),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'A4 Single Sided Color  :   RM${costs['color_single']!.toStringAsFixed(2)}/page',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/images/multi-color.svg'),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'A4 Both Sided Color     :   RM${costs['color_both']!.toStringAsFixed(2)}/page',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              });
                        },
                        child: const Text(
                          'Click here.',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF6F6EFF),
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Color(0xFF6F6EFF)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
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
                          fileDetails == null
                              ? basename(file!.path)
                              : fileDetails!['filename'],
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
                            ),
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
                    if (isUploading) {
                      return const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (orderid == null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PrinTEXComponents().greyButton(150, 'Cancel', () {
                            Navigator.of(context).pop();
                          }, fontsize: 16),
                          PrinTEXComponents().filledButton(150, 'Confirm',
                              () async {
                            if (isUploading) return;

                            double walletbalance =
                                await WalletDAO().getWalletDetails();

                            Uint8List byte =
                                (await screenshotController.capture())!;

                            //     await SupabaseB().getWalletDetails();

                            bool? isUserConfirmed =
                                await showBottomMenu(context, walletbalance);
                            isUserConfirmed ??= false;
                            if (!isUserConfirmed) return;
                            //await SupabaseB().deductBalance(cost);
                            setState(() {
                              isUploading = true;
                            });

                            var fileID = await OrderDAO().uploadFile(
                                file!,
                                basename(file!.path),
                                settings['pagecount'],
                                byte);
                            print(fileID);
                            fileDetails = {
                              'filename': basename(file!.path),
                              'fileid': fileID,
                              'pagecount': settings['pagecount']
                            };

                            var orderID = await OrderDAO().createOrder(
                                fileID,
                                cost,
                                basename(file!.path),
                                printerItem['apmid']);

                            await OrderDAO().createSettings(
                                orderID,
                                settings['layout'],
                                settings['color'],
                                settings['side'],
                                settings['pagepersheet'],
                                settings['copies'],
                                settings['pages']);
                            print(orderID);

                            previewMode = true;
                            setState(() {
                              isUploading = false;
                            });

                            setState(() {
                              orderid = orderID;

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PreviewPaidOrderPage(
                                            settings: settings,
                                            cost: cost,
                                            orderid: orderid!,
                                            fileDetails: fileDetails!,
                                            status: 'PROCESSING',
                                            apmId: printerItem['apmid'],
                                            date: date,
                                          )));
                            });
                          }, fontsize: 16)
                        ],
                      );
                    } else {
                      return PrinTEXComponents().filledButton(150, 'Print now',
                          () {
                        Switcher().SwitchPage(
                            context,
                            QRPage(
                                filename: fileDetails!['filename'],
                                totalpage: settings['pagecount'],
                                cost: cost,
                                orderid: orderid!));
                      });
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPageContent(BuildContext context, AsyncSnapshot snapshot) {
    coverBytes = snapshot.data!['bytes'];
    //calculate layout based on page per sheet
    int layout = determineRotation(snapshot.data!['layout']);
    /*

                              RotatedBox(
                                      quarterTurns: layout,
                                      child: Image.memory(
                                          snapshot.data!['bytes']))
                              */
    return Screenshot(
        controller: screenshotController,
        child: buildPreviewPrint(context, layout, snapshot));
  }

  Future<dynamic> showBottomMenu(
      BuildContext scaffoldcontext, double walletbalance) {
    double screenheight = MediaQuery.sizeOf(scaffoldcontext).height;
    print(ScaleSize.textScaleFactor(scaffoldcontext));
    double height = screenheight > 800
        ? 0.55
        : screenheight < 700
            ? 0.65
            : 0.6;
    return showModalBottomSheet(
        context: scaffoldcontext,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: height,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirm Payment',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        printerItem['printername'],
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
                                        '${printerItem['city']}, ${printerItem['state']}',
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
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(scaffoldcontext).width * 0.8,
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
                                fileDetails == null
                                    ? basename(file!.path)
                                    : fileDetails!['filename'],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  ),
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
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Balance:  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'RM${walletbalance.toStringAsFixed(2)} ',
                                  style: const TextStyle(
                                    color: Color(0xFF2728FF),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Switcher().SwitchPage(
                              //     scaffoldcontext, const ReloadWalletPage());
                            },
                            child: Ink(
                              width: 80,
                              height: 35,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF6F6EFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: const Center(
                                child: Text(
                                  '+ Reload',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Builder(builder: (scaffoldcontext) {
                    if (isUploading) {
                      return const SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PrinTEXComponents().greyButton(135, 'Cancel', () {
                          Navigator.of(scaffoldcontext).pop(false);
                        }, fontsize: 16),
                        PrinTEXComponents().filledButton(135, 'Confirm',
                            () async {
                          if (walletbalance < cost) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Your wallet is insufficient, please top-up first!',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ));

                            return;
                          }

                          Navigator.of(scaffoldcontext).pop(true);

/*
                                            await Switcher().SwitchPage(
                                                context,
                                                QRPage(
                                                    filename: basename(file.path),
                                                    totalpage: settings['pagecount'],
                                                    cost: cost,
                                                    orderid: orderID)); */
                        }, fontsize: 16)
                      ],
                    );
                  })
                ],
              ),
            ),
          );
        });
  }

  Container buildPreviewPrint(
      BuildContext context, int layout, AsyncSnapshot<dynamic> snapshot) {
    return Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width * 0.8,
        height: (MediaQuery.sizeOf(context).width * 0.8) * 1.41,
        child: Builder(builder: (context) {
          int pagepersheet = int.parse(settings['pagepersheet'][0]);
          //if pagepersheet = 2, return column, if more than 2 we use grid
          if (pagepersheet == 2) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(2, (index) {
                if (index > selectedPageBytes.length - 1) {
                  return Container();
                }
                return RotatedBox(
                    quarterTurns: layout,
                    child: ColorFiltered(
                      colorFilter: isColor
                          ? const ColorFilter.mode(
                              Colors.transparent, BlendMode.color)
                          : const ColorFilter.matrix(<double>[
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ]),
                      child: Image.memory(
                        selectedPageBytes[index],
                        height:
                            (MediaQuery.sizeOf(context).width * 0.8) * 1.41 / 2,
                      ),
                    ));
              }),
            );
          } else if (pagepersheet > 2) {
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio:
                  pagepersheet == 6 ? ((1) / (1.41 / 1.5)) : ((1) / (1.41)),
              crossAxisCount: 2,
              children: List.generate(pagepersheet, (index) {
                if (index > selectedPageBytes.length - 1) {
                  return Container();
                }
                return RotatedBox(
                    quarterTurns: layout,
                    child: ColorFiltered(
                      colorFilter: isColor
                          ? const ColorFilter.mode(
                              Colors.transparent, BlendMode.color)
                          : const ColorFilter.matrix(<double>[
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ]),
                      child: Image.memory(selectedPageBytes[index]),
                    ));
              }),
            );
          } else {
            // ignore: avoid_unnecessary_containers
            return ColorFiltered(
              colorFilter: isColor
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.color)
                  : const ColorFilter.matrix(<double>[
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]),
              child: RotatedBox(
                  quarterTurns: layout,
                  child: Image.memory(
                    snapshot.data!['bytes'],
                    height: (MediaQuery.sizeOf(context).width * 0.8) * 1.41,
                  )),
            );
          }
        }));
  }

  Future<Map<String, dynamic>> getFirstImageOfPNG(File file) async {
    var imgsettings = await decodeImageFromList(await file.readAsBytes());

    return {
      'pagecount': 1,
      'bytes': await file.readAsBytes(),
      'layout': imgsettings.width > imgsettings.height ? 3 : 0
    };
  }

  Future<Map<String, dynamic>> getFirstImageOfPDF(File file) async {
    final document = await PdfDocument.openFile(file.path);

    final page = await document.getPage(1);
    var pageImage = await page.render();
    var img = await pageImage.createImageDetached();
    var imgbytes = await img.toByteData(format: ImageByteFormat.png);
    var imgsettings = await decodeImageFromList(imgbytes!.buffer.asUint8List());

    return {
      'pagecount': document.pageCount,
      'bytes': imgbytes.buffer.asUint8List(),
      'layout': imgsettings.width > imgsettings.height ? 3 : 0
    };
  }

  int determineRotation(int layout) {
    int pagepersheet = int.parse(settings['pagepersheet'][0]);
    if (pagepersheet == 2) //if layout is portrait, force landscape, viceversa
    {
      if (layout == 0) //portrait -> landscape
      {
        return 1;
      } else {
        return 0;
      }
    } else //maintain
    {
      return layout;
    }
  }
}
