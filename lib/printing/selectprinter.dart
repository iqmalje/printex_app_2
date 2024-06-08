import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printex_app_v2/backend/apmDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/printing/printingsettings.dart';

class SelectPrinterPage extends StatefulWidget {
  
  const SelectPrinterPage({super.key});

  @override
  State<SelectPrinterPage> createState() => _SelectPrinterPageState();
}

class _SelectPrinterPageState extends State<SelectPrinterPage> {
  Position? position;

  Future<Position?> _determineAccess() async {
    bool serviceEnabled;
    Location location = Location();

    // Test if location services are enabled.
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      var status = await location.serviceEnabled();

      if (status) {
        //asks user to turn on location
        var turnedon = await location.requestService();
        if (!turnedon) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      }
      return null;
    }

    var permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      //asks for permission
      var permissionturnedon = await location.requestPermission();
    }

    if (permission == geo.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
  }

  @override
  void initState() {
    super.initState();

    _determineAccess().then((value) {
      if (value == null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Please turn on your location'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/printingpage', (route) => false);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () async {
                              await openAppSettings();
                            },
                            child: const Text('Settings')),
                      ],
                    ));
          });
        });
      } else {
        setState(() {
          position = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PrinTEXComponents().appBarWithBackButton('Select PrinTEX', context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: FutureBuilder(
            future: ApmDAO().getAPMs(position!.latitude, position!.longitude),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Nearest PrinTEX',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return buildPrinters(snapshot.data!.elementAt(index));
                        })
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildPrinters(dynamic item) {
    double metersDistance = Geolocator.distanceBetween(
        position!.latitude,
        position!.longitude,
        double.parse(item['lat'].toString()),
        double.parse(item['lng'].toString()));

    print(
        "${double.parse(item['lat'].toString())} ${double.parse(item['lng'].toString())}");
    String unit = metersDistance >= 1000 ? 'km' : 'm';
    if (metersDistance >= 1000) {
      metersDistance = metersDistance / 1000;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Image.network(
                item['pictureurl'],
                width: 80,
              ),
              const SizedBox(
                width: 13,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      item['printername'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    Text(
                      'Distance : ${double.parse(metersDistance.toString()).toStringAsFixed(2)} $unit',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 11),
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFBFF),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.25))
                          ]),
                      child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(
                              child: Text(
                            'Active',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1AFF30)),
                          ))),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 15,
                      onPressed: () {
                        item['user_position'] = position;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrderSettingPage(
                                  printerItem: item,
                                )));
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF6F6EFF),
                      )),
                ),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
