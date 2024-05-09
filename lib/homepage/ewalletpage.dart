import 'package:flutter/material.dart';
import 'package:printex_app_v2/components.dart';

class eWalletPage extends StatefulWidget {
  const eWalletPage({super.key});

  @override
  State<eWalletPage> createState() => _eWalletPageState();
}

class _eWalletPageState extends State<eWalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents().appBar('eWallet', context, null),
      body: Center(child: Text('eWallet Page')),
    );
  }
}
