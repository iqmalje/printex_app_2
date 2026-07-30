import 'package:flutter/material.dart';
import 'package:printex_app_v2/components.dart';
import 'package:printex_app_v2/model/paymentmethod.dart';

class SelectPaymentMethod extends StatefulWidget {
  PaymentMethod currentMethod;
  SelectPaymentMethod({super.key, required this.currentMethod});

  @override
  State<SelectPaymentMethod> createState() =>
      _SelectPaymentMethodState(currentMethod);
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  int chosenMethod = 0;
  List<PaymentMethod> methods = [
    PaymentMethod(
        paymentName: 'Online Banking',
        paymentImage: 'assets/images/FPX-logo.png'),
    PaymentMethod(
        paymentName: 'Touch n\' Go',
        paymentImage: 'assets/images/TNG-logo.png'),
  ];

  PaymentMethod currentMethod;
  _SelectPaymentMethodState(this.currentMethod);

  @override
  void initState() {
    super.initState();

    chosenMethod = methods.indexOf(methods.firstWhere(
        (element) => element.paymentName == currentMethod.paymentName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrinTEXComponents()
            .appBarWithBackButton('Payment Methods', context),
        body: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: ListTile.divideTiles(
                  context: context,
                  tiles: List.generate(
                      2,
                      (index) => ListTile(
                            title: buildPaymentMethod(index, methods[index]),
                          ))).toList(),
            ),
            const Spacer(),
            PrinTEXComponents().filledButton(
                MediaQuery.sizeOf(context).width * 0.8, 'Confirm', () {
              Navigator.of(context).pop(methods[chosenMethod]);
            }),
            const SizedBox(
              height: 40,
            )
          ],
        ));
  }

  Row buildPaymentMethod(int index, PaymentMethod method) {
    return Row(
      children: [
        Checkbox(
            shape: const CircleBorder(),
            value: chosenMethod == index,
            onChanged: (state) {
              if (state == null) return;
              if (state) {
                setState(() {
                  chosenMethod = index;
                });
              }
            }),
        const SizedBox(
          width: 10,
        ),
        Image.asset(method.paymentImage),
        const SizedBox(
          width: 10,
        ),
        Text(method.paymentName)
      ],
    );
  }
}
