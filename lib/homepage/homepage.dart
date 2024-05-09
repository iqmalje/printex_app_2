import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printex_app_v2/apms/apmpage.dart';
import 'package:printex_app_v2/backend/apmDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'dart:ui' as ui;

import 'package:sliding_up_panel/sliding_up_panel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? profpic;
  Position? position;
  GoogleMapController? mapController;

  var mapkey = UniqueKey();

  Future<Position?> _determineAccess() async {
    bool serviceEnabled;
    Location location = Location();

    // Test if location services are enabled.
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      var status = await location.serviceEnabled();
      print(status);
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  geo.Position pos = geo.Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      headingAccuracy: 0,
      altitude: 0,
      altitudeAccuracy: 1,
      heading: 1,
      speed: 0,
      speedAccuracy: 1);

  @override
  void initState() {
    super.initState();
    print('test');

    _determineAccess().then((value) {
      print("VALUE KAT SINI");
      print(value);
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
                              Navigator.of(context).pop();
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

    // SupabaseB().getProfilePic().then((value) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     setState(() {
    //       profpic = value;
    //     });
    //   });
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        position = pos;

        ApmDAO().getAPMs(position!.latitude, position!.longitude).then((value) {
          apms = value;
          for (var apm in apms) {
            getBytesFromAsset('assets/images/printer_marker_2.png', 120)
                .then((value) => markers.add(Marker(
                    markerId: MarkerId(apm['apmid']),
                    position: LatLng(apm['lat'], apm['lng']),
                    icon: BitmapDescriptor.fromBytes(value),
                    onTap: () {
                      /*
                        mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(apm['lat'], apm['lng']),
                                zoom: 14)));*/
                      Switcher()
                          .SwitchPage(context, APMPage(APMID: apm['apmid']));
                    },
                    infoWindow: InfoWindow(title: apm['printername']))));
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(seconds: 1)).then((value) {
              setState(() {});
            });
          });
        });
      }
    });
  }

  List<Marker> markers = [];
  List<dynamic> apms = [];

  @override
  Widget build(BuildContext context) {
    if (position != null) {
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position!.latitude, position!.longitude),
                zoom: 14)));
      }
    }
    return Scaffold(
        appBar: PrinTEXComponents()
            .appBar('PrinTEX Location', context, null, showGuide: true),
        body: SlidingUpPanel(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          maxHeight: MediaQuery.sizeOf(context).height * 0.55,
          panel: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  height: 5,
                  decoration: BoxDecoration(
                      color: const Color(0xFF6F6EFF),
                      borderRadius: BorderRadius.circular(100)),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'PrinTEX Near You',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Builder(builder: (context) {
                  if (position == null) {
                    return const CircularProgressIndicator();
                  }
                  return Builder(builder: (context) {
                    if (apms.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Center(child: Text('No APMs nearby')),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        shrinkWrap: true,
                        itemCount: apms.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildAPM(apms.elementAt(index));
                        },
                      ),
                    );
                  });
                })
              ],
            ),
          ),
          body: GoogleMap(
            key: mapkey,
            onMapCreated: (controller) => mapController = controller,
            markers: Set<Marker>.of(markers),
            initialCameraPosition: position == null
                ? const CameraPosition(target: LatLng(0, 0), zoom: 20)
                : CameraPosition(
                    target: LatLng(position!.latitude, position!.longitude)),
          ),
        ));
  }

  void reloadMap() {
    setState(() {
      mapkey = UniqueKey();
    });
  }

  Widget buildAPM(dynamic item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Switcher().SwitchPage(
                context,
                APMPage(
                  APMID: item['apmid'],
                ));
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 120,
            decoration: ShapeDecoration(
              color: const Color(0xFFF8F8F8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  item['pictureurl'],
                  height: 100,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['printername'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${item['address1']}, ${item['address2']}, ${item['city']}, ${item['state']}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
