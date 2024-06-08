// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:printex_app_v2/backend/apmDAO.dart';
import 'package:printex_app_v2/backend/orderDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/navigator/navigator.dart';
import 'package:printex_app_v2/printing/previeworder.dart';
import 'package:printex_app_v2/printing/rangepage.dart';
import 'package:printex_app_v2/printing/scanimage.dart';
import 'package:printex_app_v2/providers/fileprovider.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class OrderSettingPage extends StatefulWidget {
  dynamic printerItem;
  OrderSettingPage({super.key, required this.printerItem});

  @override
  State<OrderSettingPage> createState() => _OrderSettingPageState(printerItem);
}

class _OrderSettingPageState extends State<OrderSettingPage> {
  String pagesSetting = 'All',
      color = 'Black & White',
      layout = 'Portrait',
      side = 'Single',
      pagepersheet = '1 in 1';

  TextEditingController copies = TextEditingController(text: '1');
  // will check for sharedfile
  File? fileUploaded;
  int pagecount = 0;
  String range = '';
  bool isImage = false;
  List<Uint8List> selectedPageBytes = [];
  Map<String, dynamic> costs = {};
  dynamic printerItem;
  _OrderSettingPageState(this.printerItem);
  Widget spaceBetween() {
    return const SizedBox(
      height: 30,
    );
  }

  bool hasLoaded = false;
  @override
  void initState() {
    List<SharedMediaFile> sharedFiles = NavigationService
        .navigatorKey.currentContext!
        .watch<FileShareProvider>()
        .sharedFiles;

    if (sharedFiles.isNotEmpty) {
      this.fileUploaded = File(sharedFiles.first.path);
    }
    ApmDAO().getAPMCost(printerItem['apmid']).then((value) => {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              costs = value;
              print("costs is $costs");
              hasLoaded = true;
            });
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    double metersDistance = Geolocator.distanceBetween(
        printerItem['user_position']!.latitude,
        printerItem['user_position']!.longitude,
        printerItem['lat'],
        printerItem['lng']);
    String unit = metersDistance >= 1000 ? 'km' : 'm';
    if (metersDistance >= 1000) {
      metersDistance = metersDistance / 1000;
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () async {
            File? tempFile =
                await Switcher().SwitchPage(context, ScanDocumentPage());
            if (tempFile != null) {
              context.read<FileShareProvider>().changeFileShared([]);
              fileUploaded = tempFile;
              isImage = true;
              setState(() {});
            }
          },
        ),
        resizeToAvoidBottomInset: false,
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
                    'Printing Order',
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
        body: Builder(builder: (context) {
          if (!hasLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 50.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 0,
                      maxHeight: MediaQuery.sizeOf(context).height - 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          height: 115,
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
                                        MainAxisAlignment.spaceAround,
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
                                      Text(
                                        'Distance : ${metersDistance.toStringAsFixed(2)} $unit',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 80,
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFFFFBFF),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 2,
                                                      color: Colors.black
                                                          .withOpacity(0.25))
                                                ]),
                                            child: const Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Center(
                                                    child: Text(
                                                  'Active',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF1AFF30)),
                                                ))),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Change',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Color(0xFF6F6EFF),
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF6F6EFF)),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/images/dollar_logo.svg'),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Check the PrinTEX pricing? ',
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 13),
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
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.8,
                                              height: 280,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFF9F9F9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.25))
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.network(
                                                            printerItem[
                                                                'pictureurl'],
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
                                                                      fontSize:
                                                                          16),
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
                                                                      fontSize:
                                                                          13),
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
                                                        color: const Color(
                                                            0xFFF9F9F9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.25))
                                                        ]),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
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
                                                                SvgPicture
                                                                    .asset(
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
                                                                      fontSize:
                                                                          17),
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
                                                                  'A4 Single Sided B&w    :   RM${costs['black_white_single'].toStringAsFixed(2)}/page',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          13,
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
                                                                  'A4 Both Sided B&W      :   RM${costs['black_white_both'].toStringAsFixed(2)}/page',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          13,
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
                                                                  'A4 Single Sided Color  :   RM${costs['color_single'].toStringAsFixed(2)}/page',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          13,
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
                                                                  'A4 Both Sided Color     :   RM${costs['color_both'].toStringAsFixed(2)}/page',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          13,
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
                        height: 30,
                      ),
                      Material(
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(allowedExtensions: [
                              'pdf',
                              'png',
                              'jpg',
                              'jpeg'
                            ], type: FileType.custom);

                            if (result != null) {
                              File tempfile = File(result.files.single.path!);

                              if (tempfile.lengthSync() > 5 * 10000000) {
                                //too big
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'File too big!',
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
                                                style: TextStyle(
                                                    fontFamily: 'Poppins'),
                                              ))
                                        ],
                                      );
                                    });

                                return;
                              }

                              setState(() {
                                fileUploaded = tempfile;
                              });
                              String fileExtension =
                                  extension(fileUploaded!.path).toLowerCase();

                              if (fileExtension == '.png' ||
                                  fileExtension == '.jpg' ||
                                  fileExtension == '.jpeg') {
                                range = '1';
                                pagecount = 1;
                                selectedPageBytes = [
                                  await fileUploaded!.readAsBytes()
                                ];
                              } else {
                                Map? temprange = await Switcher().SwitchPage(
                                    context,
                                    PickRangePage(file: fileUploaded!));

                                if (temprange == null) {
                                  var doc = await PdfDocument.openFile(
                                      fileUploaded!.path);
                                  range = '1-${doc.pageCount}';
                                } else {
                                  range = temprange['range'];
                                  pagecount = temprange['pagecount'];
                                  selectedPageBytes =
                                      temprange['selectedPagesBytes'];
                                }
                              }

                              print(range);

                              setState(() {});
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Ink(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            height: 80,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF6F6EFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      fileUploaded == null
                                          ? 'Please click here to upload your file'
                                          : basename(fileUploaded!.path),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: (fileUploaded == null
                                              ? const Color(0xFFD9D9D9)
                                              : Colors.white),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Builder(builder: (context) {
                                    if (fileUploaded == null) {
                                      return Container();
                                    } else {
                                      return Builder(builder: (context) {
                                        if (pagecount == 0) {
                                          return Builder(builder: (context) {
                                            if (!isImage) {
                                              return FutureBuilder(
                                                  future: getPDFPageCount(
                                                      fileUploaded!),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const CircularProgressIndicator();
                                                    }

                                                    pagecount = snapshot.data!;
                                                    return Text(
                                                      ' (${snapshot.data!} pages)',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    );
                                                  });
                                            } else {
                                              return const Text(
                                                '1 pages)',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              );
                                            }
                                          });
                                        } else {
                                          return Text(
                                            ' ($pagecount pages)',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          );
                                        }
                                      });
                                    }
                                  })
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      spaceBetween(),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFFFFF),
                          shadows: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 232, 232, 232),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                                spreadRadius: 1)
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Printing Color',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              PrinTEXComponents().dropdownButtonString([
                                const DropdownMenuItem(
                                  value: 'Black & White',
                                  child: Text(
                                    'Black & White',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const DropdownMenuItem(
                                  value: 'Color',
                                  child: Text('Color'),
                                ),
                              ], MediaQuery.sizeOf(context).width * 0.3, 45,
                                  color, (val) {
                                setState(() {
                                  color = val.toString();
                                });
                              })
                            ],
                          ),
                        ),
                      ),
                      spaceBetween(),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFFFFF),
                          shadows: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 232, 232, 232),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                                spreadRadius: 1)
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Printing Side',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              PrinTEXComponents().dropdownButtonString([
                                const DropdownMenuItem(
                                  value: 'Single',
                                  child: Text('Single'),
                                ),
                                const DropdownMenuItem(
                                  value: 'Flip on long edge',
                                  child: Text(
                                    'Long edge',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const DropdownMenuItem(
                                  value: 'Flip on short edge',
                                  child: Text(
                                    'Short edge',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ], MediaQuery.sizeOf(context).width * 0.3, 45,
                                  side, (val) {
                                setState(() {
                                  side = val.toString();
                                });
                              })
                            ],
                          ),
                        ),
                      ),
                      spaceBetween(),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFFFFF),
                          shadows: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 232, 232, 232),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                                spreadRadius: 1)
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Page per sheet',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              PrinTEXComponents().dropdownButtonString([
                                const DropdownMenuItem(
                                  value: '1 in 1',
                                  child: Text('1 in 1'),
                                ),
                                const DropdownMenuItem(
                                  value: '2 in 1',
                                  child: Text('2 in 1'),
                                ),
                                const DropdownMenuItem(
                                  value: '4 in 1',
                                  child: Text('4 in 1'),
                                ),
                                const DropdownMenuItem(
                                  value: '6 in 1',
                                  child: Text('6 in 1'),
                                ),
                              ], MediaQuery.sizeOf(context).width * 0.3, 45,
                                  pagepersheet, (val) {
                                setState(() {
                                  pagepersheet = val.toString();
                                });
                              })
                            ],
                          ),
                        ),
                      ),
                      spaceBetween(),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFFFFF),
                          shadows: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 232, 232, 232),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                                spreadRadius: 1)
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Copies',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                width: MediaQuery.sizeOf(context).width * 0.3,
                                height: 45,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextField(
                                    controller: copies,
                                    scrollPadding:
                                        const EdgeInsets.only(bottom: 500),
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      spaceBetween(),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.sizeOf(context).width * 0.1 +
                                    10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'Total cost: ',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'RM ${priceCalculator(pagecount).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2728FF)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.sizeOf(context).width * 0.1 +
                                    10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Platform fee of RM${double.parse(costs['service_fee'].toString()).toStringAsFixed(2)} is included',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.sizeOf(context).width * 0.15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrinTEXComponents().greyButton(
                                MediaQuery.sizeOf(context).width * 0.3,
                                'Cancel', () {
                              Navigator.of(context).pop();
                            }),
                            PrinTEXComponents().filledButton(
                                MediaQuery.sizeOf(context).width * 0.3,
                                'Confirm', () async {
                              if (fileUploaded == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please upload a file first')));
                                return;
                              }

                              int copiesInt = copies.text == ''
                                  ? 0
                                  : int.parse(copies.text);

                              if (copiesInt <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Invalid copies value!')));
                                return;
                              }
                              await Switcher().SwitchPage(
                                context,
                                PreviewOrder(
                                  settings: {
                                    'layout': layout,
                                    'color': color,
                                    'side': side,
                                    'pagepersheet': pagepersheet,
                                    'copies': copiesInt,
                                    'pages': range,
                                    'pagecount': pagecount,
                                  },
                                  date: DateTime.now(),
                                  file: fileUploaded!,
                                  printerItem: printerItem,
                                  selectedPageBytes: selectedPageBytes,
                                  cost: priceCalculator(pagecount),
                                  costs: costs,
                                ),
                              );

                              //TODO: check if uploaded, if it is push to printing order page
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  double priceCalculator(int pagecount) {
    double basePrice = 0;
    if (side == 'Single' || pagecount == 1) {
      if (color == 'Black & White') {
        basePrice = 0.2;
      } else {
        basePrice = 0.75;
      }
    } else {
      if (color == 'Black & White') {
        basePrice = 0.15;
      } else {
        basePrice = 0.6;
      }
    }

    int copiesInt = copies.text != '' ? int.parse(copies.text) : 0;
    pagecount =
        (double.parse(pagecount.toString()) / double.parse(pagepersheet[0]))
            .ceil();
    return (pagecount * basePrice * copiesInt + 0.1);
  }

  Future<int> getPDFPageCount(File file) async {
    var document = await PdfDocument.openFile(file.path);

    return document.pageCount;
  }
}
