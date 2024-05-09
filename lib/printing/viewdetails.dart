import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:printex_app_v2/backend/orderDAO.dart';

class ViewDetailsPage extends StatefulWidget {
  final dynamic settings, fileDetails;
  const ViewDetailsPage(
      {super.key, required this.settings, required this.fileDetails});

  @override
  State<ViewDetailsPage> createState() =>
      _ViewDetailsPageState(settings, fileDetails);
}

class _ViewDetailsPageState extends State<ViewDetailsPage> {
  int crossAxis = 2;
  PdfDocument? pdf;
  final dynamic settings, fileDetails;

  _ViewDetailsPageState(this.settings, this.fileDetails);
  @override
  Widget build(BuildContext context) {
    print(settings);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: const Color(0xFF6F6EFF),
                iconSize: 25,
              ),
            ),
            const Text(
              'View Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            IconButton(
                onPressed: () {
                  if (crossAxis == 2) {
                    setState(() {
                      crossAxis = 1;
                    });
                  } else {
                    setState(() {
                      crossAxis = 2;
                    });
                  }
                },
                icon: crossAxis == 2
                    ? const Icon(
                        Icons.grid_view,
                        size: 30,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.width_full,
                        size: 30,
                        color: Colors.white,
                      ))
          ],
        ),
        backgroundColor: const Color(0xFF6F6EFF),
      ),
      body: FutureBuilder(
          future: buildPageBySettings(fileDetails['fileid']),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return GridView.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                childAspectRatio: (1 / 1.41),
                crossAxisCount: crossAxis,
                children: buildPreviewPrint(context, snapshot.data!['layout'],
                    snapshot.data!['pagesBytes']));
          }),
    );
  }

  Future<List<Uint8List>> getPagesBytes(PdfDocument pdf) async {
    int pagepersheet = int.parse(settings['pagepersheet'][0]);
    int totalpage = fileDetails['pagecount'];
    List<Uint8List> pageBytes = [];
    var nums = parseRange(settings['pages']);
    print("total page  = $totalpage");
    for (var i = 0; i < totalpage; i++) {
      final page = await pdf.getPage(nums[i]);

      var pageImage = await page.render();
      var img = await pageImage.createImageDetached();
      var imgbytes = await img.toByteData(format: ImageByteFormat.png);
      //pageBytes.add(imgbytes!.buffer.asUint8List());

      pageBytes.add(imgbytes!.buffer.asUint8List());
    }
    print("habis");
    //test

    print(nums);
    return pageBytes;
  }

  Future<Map> buildPageBySettings(String fileid) async {
    PdfDocument pdf = await OrderDAO().downloadFile(fileid);
    Map firstImagePDF = await getFirstImageOfPDF(pdf);
    int layout = determineRotation(firstImagePDF['layout']);
    List<Uint8List> pagesBytes = await getPagesBytes(pdf);

    return {'pagesBytes': pagesBytes, 'layout': layout};
  }

  Future<Map<String, dynamic>> getFirstImageOfPDF(PdfDocument pdf) async {
    final document = pdf;

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

  List<int> parseRange(String range) {
    List<int> result = [];
    List<String> parts = range.split(',');

    for (var part in parts) {
      if (part.contains('-')) {
        List<int> rangeValues =
            part.split('-').map((e) => int.parse(e)).toList();
        if (rangeValues.length == 2) {
          result.addAll(List.generate(rangeValues[1] - rangeValues[0] + 1,
              (index) => rangeValues[0] + index));
        }
      } else {
        result.add(int.parse(part));
      }
    }

    return result;
  }

  List<Widget> buildPreviewPrint(
      BuildContext context, int layout, List<Uint8List> pagesByte) {
    bool isColor = settings['color'] != 'Black & White';
    int pagepersheet = int.parse(settings['pagepersheet'][0]);

    List<List<Uint8List>> pagesByte0 = [];
    List<Uint8List> temp;
    int paperindex = 0;
    print(" aah = ${(pagesByte.length)}");
    for (var i = 0; i < (pagesByte.length / pagepersheet).ceil(); i++) {
      if (i > pagesByte.length) break;
      temp = [];
      for (var j = 0; j < pagepersheet; j++) {
        print("paperindex = $paperindex");
        temp.add(pagesByte[paperindex]);
        paperindex++;
        if (paperindex >= pagesByte.length) break;
      }
      pagesByte0.add(temp);
    }

    List<Widget> pagesWidget = [];

    for (var singlePage in pagesByte0) {
      pagesWidget.add(SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: (MediaQuery.sizeOf(context).width) * 1.41,
          child: Builder(builder: (context) {
            print('PAGE PER SHEET = $pagepersheet');
            //if pagepersheet = 2, return column, if more than 2 we use grid
            if (pagepersheet == 2) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(2, (index) {
                  if (index > singlePage.length - 1) {
                    return Container(
                      height:
                          ((MediaQuery.sizeOf(context).width) * 1.41 / 4) - 11,
                      color: Colors.white,
                    );
                  }
                  return RotatedBox(
                      quarterTurns: layout,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            isColor ? Colors.transparent : Colors.grey,
                            BlendMode.saturation),
                        child: Image.memory(singlePage[index]),
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
                  print(index);
                  if (index > singlePage.length - 1) {
                    print("PATUT PRINT SINI");
                    return Container(
                      color: Colors.white,
                    );
                  } else {
                    return RotatedBox(
                        quarterTurns: layout,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              isColor ? Colors.transparent : Colors.grey,
                              BlendMode.saturation),
                          child: Image.memory(
                            singlePage[index],
                            height: 100,
                          ),
                        ));
                  }
                }),
              );
            } else {
              // ignore: avoid_unnecessary_containers
              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                    isColor ? Colors.transparent : Colors.grey,
                    BlendMode.saturation),
                child: RotatedBox(
                    quarterTurns: layout, child: Image.memory(singlePage[0])),
              );
            }
          })));
    }

    return pagesWidget;
  }
}
