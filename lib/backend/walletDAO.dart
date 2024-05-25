import 'package:supabase_flutter/supabase_flutter.dart';

class WalletDAO {
  SupabaseClient supabase = Supabase.instance.client;

  Future<double> getWalletDetails() async {
    print("getting wallet details");
    var result = await supabase.from('wallet').select('balance');
    print("result is $result");
    return double.parse(result[0]['balance'].toString());
  }

  Future<void> addWalletBalance(double amount, String transactionID) async {
    var balance = await supabase.from('wallet').select('balance');

    await supabase
        .from('wallet')
        .update({'balance': balance[0]['balance'] + amount}).eq(
            'accountid', supabase.auth.currentUser!.id);

    await supabase
        .from('transactions')
        .update({'status': 'SUCCESSFUL'}).eq('transactionid', transactionID);
  }

  Future<List<dynamic>> getTransactions() async {
    var transactionResult = await supabase
        .from('transactions')
        .select('*')
        .order('date', ascending: false);

    for (var transaction in transactionResult) {
      transaction['date'] =
          DateTime.parse(transaction['date']).add(const Duration(hours: 8));
    }
    return transactionResult;
  }

  Future<String> addPendingReload(double amount) async {
    var data = await supabase.from('transactions').insert({
      'accountid': supabase.auth.currentUser!.id,
      'type': 'RELOAD',
      'amount': amount,
      'status': 'PENDING'
    }).select();

    return data[0]['transactionid'];
  }

  Future<dynamic> getPaymentIntent(String transactionid, int amount) async {
    var data = await supabase.functions.invoke('init-payment-stripe',
        body: {'transactionid': transactionid, 'amount': amount});
    return data.data;
  }
}
