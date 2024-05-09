import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatefulWidget {
  String filename;
  int totalpage;
  double cost;
  String orderid;
  QRPage(
      {super.key,
      required this.filename,
      required this.totalpage,
      required this.cost,
      required this.orderid});

  @override
  State<QRPage> createState() =>
      _QRPageState(filename, totalpage, cost, orderid);
}

class _QRPageState extends State<QRPage> {
  String filename;
  int totalpage;
  double cost;
  String orderid;
  _QRPageState(this.filename, this.totalpage, this.cost, this.orderid);

  @override
  Widget build(BuildContext context) {
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
                  'QR Code Order',
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
        child: Container(
            width: 360,
            height: 550,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Please scan the QR code with the respective PrinTEX scanner to print your order.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
                QrImageView(
                  data: orderid,
                  embeddedImage:
                      const AssetImage('assets/images/printex_logo_white.png'),
                  size: MediaQuery.sizeOf(context).width * 0.7,
                ),
                SizedBox(
                  width: 271,
                  child: Text(
                    filename,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 103,
                  child: Text(
                    'Total pages: $totalpage',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF626262),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total cost:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        Text(
                          ' RM${cost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF2728FF),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                    const Align(
                        alignment: Alignment.center,
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
                const SizedBox(
                  height: 20,
                )
              ],
            )),
      ),
    );
  }
}
