import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';

class PickRangePage extends StatefulWidget {
  File file;
  PickRangePage({super.key, required this.file});

  @override
  State<PickRangePage> createState() => _PickRangePageState(file);
}

class _PickRangePageState extends State<PickRangePage> {
  File file;

  _PickRangePageState(this.file);

  List<bool> selectedPage = [];
  List<Uint8List> pagesBytes = [];
  var pagesImageSettings = <dynamic>[];
  List<Uint8List> selectedPagesBytes = [];
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFirstImageOfPDF(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if (!isLoaded) {
            selectedPage.clear();
            selectedPage =
                List.generate(snapshot.data!.pageCount, (index) => true);
          }

          isLoaded = true;
          return Scaffold(
              backgroundColor: const Color.fromARGB(255, 230, 230, 230),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (!selectedPage.contains(true)) {
                            selectedPage = List.generate(
                                snapshot.data!.pageCount, (index) => true);
                          } else {
                            selectedPage = List.generate(
                                snapshot.data!.pageCount, (index) => false);
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 190, 190, 190),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            !selectedPage.contains(true)
                                ? 'Select all page'
                                : 'Unselect all page',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (!selectedPage.contains(true)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please choose atleast one page!')));
                        return;
                      }
                      String range = '';
                      List<int> pagesWant = [];
                      //remove some pages that we wont use

                      for (var i = 0; i < selectedPage.length; i++) {
                        if (selectedPage[i]) {
                          range += '${i + 1},';
                          selectedPagesBytes.add(pagesBytes.elementAt(i));
                          pagesWant.add(i);
                        }
                      }
                      print("pages want  = $pagesWant");

                      range = range.substring(0, range.length - 1);
                      Map rangeDetails =
                          formatNumberRanges(range, snapshot.data!);
                      Navigator.of(context).pop({
                        'range': rangeDetails['range'],
                        'pagecount': rangeDetails['pagecount'],
                        'selectedPagesBytes': selectedPagesBytes,
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                          color: const Color(0xFF6F6EFF),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.count(
                  childAspectRatio: (1 / 1.41),
                  crossAxisCount: 2,
                  children: List.generate(snapshot.data!.pageCount,
                      (index) => buildContainerPreview(snapshot.data!, index)),
                ),
              ));
        });
  }

  Widget buildContainerPreview(PdfDocument document, int index) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Ink(
              height: 1000,
              color: Colors.white,
              child: RotatedBox(
                  //0 is normal, while 3 is rotated
                  quarterTurns: pagesImageSettings.elementAt(index).width >
                          pagesImageSettings.elementAt(index).height
                      ? 3
                      : 0,
                  child: ClipRRect(
                      child: Image.memory(pagesBytes.elementAt(index)))),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Checkbox(
                    value: selectedPage[index],
                    onChanged: (val) {
                      setState(() {
                        selectedPage[index] = !selectedPage[index];
                      });
                    }))
          ],
        ));
  }

  Map formatNumberRanges(String input, PdfDocument document) {
    // Split the input string by commas and convert to a list of integers
    final List<int> numbers =
        input.split(',').map((e) => int.parse(e)).toList();

    if (numbers.isEmpty) {
      return {
        'range': '1-${document.pageCount}',
        'pagecount': document.pageCount
      }; // Handle empty input
    }

    // Sort the numbers in ascending order
    numbers.sort();

    final List<String> ranges = [];
    int start = numbers[0];
    int prev = numbers[0];

    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] - prev > 1) {
        // If there's a gap, add the range to the list
        if (start == prev) {
          ranges.add('$start');
        } else {
          ranges.add('$start-$prev');
        }
        start = numbers[i];
      }
      prev = numbers[i];
    }

    // Handle the last range
    if (start == prev) {
      ranges.add('$start');
    } else {
      ranges.add('$start-$prev');
    }

    // Join the ranges with commas and return the formatted string
    return {'range': ranges.join(','), 'pagecount': numbers.length};
  }

  Future<PdfDocument> getFirstImageOfPDF() async {
    List<Uint8List> lists = [];
    List<dynamic> decodedImage = [];
    var document = await PdfDocument.openFile(file.path);
    for (var i = 0; i < document.pageCount; i++) {
      final page = await document.getPage(i + 1);
      var pageImage = await page.render();
      var img = await pageImage.createImageDetached();
      var imgbytes = await img.toByteData(format: ImageByteFormat.png);
      lists.add(imgbytes!.buffer.asUint8List());
      var imgsettings =
          await decodeImageFromList(imgbytes.buffer.asUint8List());
      decodedImage.add(imgsettings);
    }

    pagesBytes = lists;

    pagesImageSettings = decodedImage;

    return document;
  }
}
