import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:printex_app_v2/backend/walletDAO.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/model/paymentmethod.dart';
import 'package:printex_app_v2/wallet/selectpayment.dart';

class ReloadWalletPage extends StatefulWidget {
  const ReloadWalletPage({super.key});

  @override
  State<ReloadWalletPage> createState() => _ReloadWalletPageState();
}

class _ReloadWalletPageState extends State<ReloadWalletPage> {
  TextEditingController amount = TextEditingController();
  String amountChosen = '0.00';
  PaymentMethod methodChosen = PaymentMethod(
      paymentName: 'Online Banking',
      paymentImage: 'assets/images/FPX-logo.png');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
                    'Reload',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 70,
                    decoration: const BoxDecoration(color: Color(0xFFF8F8F8)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Color(0xFF6A6A6A),
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Don\'t worry, your data is kept accordance to the law and protected by us!',
                              style: TextStyle(
                                color: Color(0xFF6A6A6A),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 190,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFDDEFFD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 70,
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 21),
                                child: TextField(
                                  style: const TextStyle(
                                    color: Color(0xFF6F6EFF),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                  ),
                                  controller: amount,
                                  inputFormatters: [
                                    CurrencyTextInputFormatter.currency(
                                        symbol: '')
                                  ],
                                  onChanged: (val) {
                                    setState(() {
                                      amountChosen = val;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          color: Color(0xFFC5C5C5)),
                                      prefix: Text(
                                        'RM ',
                                        style: TextStyle(
                                          color: Color(0xFF6F6EFF),
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          height: 0,
                                        ),
                                      ),
                                      labelText: 'Enter your amount'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 30,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Min. reload amount is RM3.00',
                                  style: TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 84,
                                height: 35,
                                decoration: ShapeDecoration(
                                  color: amountChosen == '3.00'
                                      ? const Color(0xFF6F6EFF)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: amountChosen == '3.00'
                                            ? const Color(0xFF6F6EFF)
                                            : const Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        amountChosen = '3.00';
                                        amount.text = '3.00';
                                      });
                                    },
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'RM ',
                                              style: TextStyle(
                                                color: amountChosen == '3.00'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '3.00',
                                              style: TextStyle(
                                                color: amountChosen == '3.00'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 84,
                                height: 35,
                                decoration: ShapeDecoration(
                                  color: amountChosen == '5.00'
                                      ? const Color(0xFF6F6EFF)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: amountChosen == '5.00'
                                            ? const Color(0xFF6F6EFF)
                                            : const Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        amountChosen = '5.00';
                                        amount.text = '5.00';
                                      });
                                    },
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'RM ',
                                              style: TextStyle(
                                                color: amountChosen == '5.00'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '5.00',
                                              style: TextStyle(
                                                color: amountChosen == '5.00'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 84,
                                height: 35,
                                decoration: ShapeDecoration(
                                  color: amountChosen == '10.00'
                                      ? const Color(0xFF6F6EFF)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: amountChosen == '10.00'
                                            ? const Color(0xFF6F6EFF)
                                            : const Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        amountChosen = '10.00';
                                        amount.text = '10.00';
                                      });
                                    },
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'RM ',
                                              style: TextStyle(
                                                color: amountChosen == '10.00'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '10.00',
                                              style: TextStyle(
                                                color: amountChosen == '10.00'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buildPaymentMethod(context),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      //stripe payment

                      if (double.parse(amount.text) * 100 < 300) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Minimum reload amount is RM3.00!')));
                        return;
                      }

                      var transactionid = await WalletDAO()
                          .addPendingReload(double.parse(amount.text));
                      /*
                      String body =
                          'amount=${(double.parse(amount.text) * 100).toInt()}&currency=myr&description=$transactionid&payment_method_types[]=fpx';
                      var paymentIntent = await http
                          .post(
                              Uri.parse(
                                  'https://api.stripe.com/v1/payment_intents'),
                              headers: {
                                'Authorization':
                                    'Bearer ${dotenv.env['STRIPE_TEST_SECRET_KEY']}',
                                'Content-type':
                                    'application/x-www-form-urlencoded'
                              },
                              body: body)
                          .then((value) => json.decode(value.body));
                          */

                      var data = await WalletDAO().getPaymentIntent(
                          transactionid,
                          (double.parse(amount.text) * 100).toInt());

                      var paymentIntent = data['data'];
                      try {
                        // await Stripe.instance.confirmPayment(
                        //     paymentIntentClientSecret:
                        //         paymentIntent['client_secret'],
                        //     data: const PaymentMethodParams.fpx(
                        //         paymentMethodData: PaymentMethodDataFpx(
                        //             testOfflineBank: false)));

                        await WalletDAO().addWalletBalance(
                            double.parse(amount.text), transactionid);

                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                        //await SupabaseB().setStatusFailedReload(transactionid);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Payment failed, please try again')));
                      }
                    },
                    borderRadius: BorderRadius.circular(5),
                    child: Ink(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      height: 50,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF6F6EFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Center(
                        child: Text(
                          'Reload eWallet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
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
            ],
          ),
        ),
      ),
    );
  }

  Container buildPaymentMethod(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: 140,
      decoration: ShapeDecoration(
        color: const Color(0xFFDDEFFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Methods',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 70,
              width: MediaQuery.sizeOf(context).width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(methodChosen.paymentImage),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(methodChosen.paymentName),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        PaymentMethod? method = await Switcher().SwitchPage(
                            context,
                            SelectPaymentMethod(
                              currentMethod: methodChosen,
                            ));

                        if (method == null) return;
                        setState(() {
                          methodChosen = method;
                        });
                      },
                      icon: const Icon(Icons.arrow_forward_ios))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
