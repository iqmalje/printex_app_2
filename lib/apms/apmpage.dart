// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:printex_app_v2/backend/apmDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class APMPage extends StatefulWidget {
  String APMID;
  APMPage({super.key, required this.APMID});

  @override
  State<APMPage> createState() => _APMPageState(APMID);
}

class _APMPageState extends State<APMPage> {
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String selectedDay = '';
  String APMID;
  _APMPageState(this.APMID);
  @override
  void initState() {
    selectedDay = days.first;
    super.initState();
  }

  final cardController = PageController(viewportFraction: 1, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApmDAO().getAPMDetails(APMID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 20,
              width: 20,
              child: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          } else {
            var item = snapshot.data!;
            print(item);
            return Scaffold(
              appBar: PrinTEXComponents()
                  .appBarWithBackButton('PrinTEX Details', context),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 240,
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          child: PageView(
                            controller: cardController,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 240,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(item['pictureurl']),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              //https://hxebdlcxtauthsyfyprv.supabase.co/storage/v1/object/public/apms/fc6b2565-917a-407d-96b6-af299374c2a8/IMG_20231218_143249.jpg
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 240,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(item['picture_url_2']),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SmoothPageIndicator(
                          effect: const ScrollingDotsEffect(
                              dotWidth: 10,
                              dotHeight: 10,
                              paintStyle: PaintingStyle.fill),
                          controller: cardController,
                          count: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x7F2728FF),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 310,
                                  child: Text(
                                    item['printername'],
                                    style: const TextStyle(
                                      color: Color(0xFF3A3A3A),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Location:',
                                  style: TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${item['apmaddresses']['address1']}, ${item['apmaddresses']['address2']}, ${item['apmaddresses']['city']}, ${item['apmaddresses']['state']}',
                                  style: const TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Operation Hours:',
                                  style: TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                Row(
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          value: selectedDay,
                                          style: const TextStyle(
                                            color: Color(0xFF3A3A3A),
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                          items: days
                                              .map<DropdownMenuItem<String>>(
                                                  (e) {
                                            return DropdownMenuItem<String>(
                                                value: e, child: Text(e));
                                          }).toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                selectedDay = val;
                                              });
                                            }
                                          }),
                                    ),
                                    const SizedBox(
                                      width: 0,
                                    ),
                                    Text(
                                      item['operatinghours'][0]
                                          [selectedDay.toLowerCase()],
                                      style: const TextStyle(
                                        color: Color(0xFF3A3A3A),
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        if ((await MapLauncher.isMapAvailable(
                                            MapType.google))!) {
                                          await MapLauncher.showMarker(
                                              mapType: MapType.google,
                                              coords: Coords(
                                                  item['apmaddresses']['lat'],
                                                  item['apmaddresses']['lng']),
                                              title: item['printername']);
                                        } else {
                                          final availableMaps =
                                              await MapLauncher.installedMaps;

                                          availableMaps.first.showMarker(
                                              coords: Coords(
                                                  item['apmaddresses']['lat'],
                                                  item['apmaddresses']['lng']),
                                              title: item['printername']);
                                        }
                                      },
                                      child: Ink(
                                        width: 91,
                                        height: 26,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF6F6EFF),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 66,
                                            child: Text(
                                              'Direction',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
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
                          height: 200,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x7F2728FF),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'PrinTEX Details',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Printer Type: ',
                                                style: TextStyle(
                                                  color: Color(0xFF3A3A3A),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: item['apmdetails'][0]
                                                    ['type'],
                                                style: const TextStyle(
                                                  color: Color(0xFF3A3A3A),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'Black & White Printing: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item['apmdetails'][0]
                                                          ['bwprint']
                                                      ? 'Yes '
                                                      : 'No ',
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Color Printing: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item['apmdetails'][0]
                                                          ['colorprint']
                                                      ? 'Yes '
                                                      : 'No ',
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Both-Sided Printing: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item['apmdetails'][0]
                                                          ['bothsideprint']
                                                      ? 'Yes '
                                                      : 'No ',
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Paper Size: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item['apmdetails'][0]
                                                      ['papersize'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
