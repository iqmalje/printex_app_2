// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:printex_app_v2/backend/orderDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/printing/previewpaidorder.dart';
import 'package:printex_app_v2/printing/printingsettings.dart';
import 'package:printex_app_v2/printing/selectprinter.dart';

class PrintingOrderPage extends StatefulWidget {
  const PrintingOrderPage({super.key});

  @override
  State<PrintingOrderPage> createState() => _PrintingOrderPageState();
}

class _PrintingOrderPageState extends State<PrintingOrderPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> ordersActive = [], ordersCompleted = [];
  List<String> imageUrls = [];
  String? profpic;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents().appBar('Printing Order', context, null),
      body: Center(
        child: FutureBuilder(
            future: OrderDAO().getOrdersByAccounts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              ordersActive = snapshot.data!
                  .where((element) =>
                      element['status'] == 'PROCESSING' ||
                      element['status'] == 'FAILED' ||
                      element['status'] == 'PRINTING')
                  .toList();
              ordersCompleted = snapshot.data!
                  .where((element) => element['status'] == 'DONE')
                  .toList();
              return Padding(
                padding:
                    EdgeInsets.only(top: (snapshot.data!.isEmpty ? 0.0 : 20)),
                child: Builder(builder: (context) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height - 70 - 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            controller: tabController,
                            tabs: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0, top: 10),
                                child: Text(
                                  'Active',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0, top: 10),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              )
                            ]),
                        Expanded(
                          child:
                              TabBarView(controller: tabController, children: [
                            Builder(builder: (context) {
                              if (ordersActive.isEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/uploadfile.svg',
                                      semanticsLabel: 'Upload File',
                                      height: 310,
                                      width: 280,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Let\'s Start Upload Your File',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Switcher().SwitchPage(
                                            context, const SelectPrinterPage());
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Click here to upload',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF2728FF),
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0xFF2728FF)),
                                      ),
                                    )
                                  ],
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: ordersActive.length,
                                padding: EdgeInsets.only(
                                    right:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                    top: 20),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: buildFileUploaded(
                                        ordersActive.elementAt(index), context),
                                  );
                                },
                              );
                            }),
                            Builder(builder: (context) {
                              if (ordersCompleted.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/empty_order.svg',
                                        semanticsLabel: 'Empty Order',
                                        height: 310,
                                        width: 280,
                                      ),
                                      const Text(
                                        'No completed order yet',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: ordersCompleted.length,
                                padding: EdgeInsets.only(
                                    right:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                    top: 20),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: buildFileUploaded(
                                        ordersCompleted.elementAt(index),
                                        context),
                                  );
                                },
                              );
                            }),
                          ]),
                        ),
                      ],
                    ),
                  );
                }),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2728FF),
        shape: const CircleBorder(),
        onPressed: () async {
          await Switcher().SwitchPage(context, const SelectPrinterPage());
          setState(() {});
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildFileUploaded(dynamic order, BuildContext context) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];

    double price = double.parse(order['cost'].toString());
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () async {
          var settings = await OrderDAO().fetchOrderSettings(order['orderid']);
          settings['pagecount'] = order['files']['pagecount'];

          Map filedetails = order['files'];
          filedetails['fileid'] = order['fileid'];
          await Switcher().SwitchPage(
              context,
              PreviewPaidOrderPage(
                settings: settings,
                fileDetails: order['files'],
                status: order['status'],
                cost: double.parse(order['cost'].toString()),
                orderid: order['orderid'],
                apmId: order['target_apm'],
              ));

          setState(() {});
        },
        child: Ink(
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: 100,
            decoration: ShapeDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        SizedBox(
                            width: 50,
                            child: Image.network(order['coverimage'])),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['files']['filename'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${(order['files']['pagecount'] / int.parse(order['settings']['pagepersheet'][0])).ceil()} pages',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${order['date'].day} ${months[order['date'].month - 1]} ${DateFormat('h:mm a').format(order['date'])}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'RM${order['cost'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2728FF)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
