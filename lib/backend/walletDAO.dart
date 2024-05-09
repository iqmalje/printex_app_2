import 'package:supabase_flutter/supabase_flutter.dart';

class WalletDAO {
  SupabaseClient supabase = Supabase.instance.client;

  Future<double> getWalletDetails() async {
    var result = await supabase.from('wallet').select('balance');

    return double.parse(result[0]['balance'].toString());
  }
}
