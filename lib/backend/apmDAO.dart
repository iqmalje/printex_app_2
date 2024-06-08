import 'package:supabase_flutter/supabase_flutter.dart';

class ApmDAO {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> getAPMs(double lat, double lng) async {
    var result = await supabase.rpc('get_apm_within_radius',
        params: {'userlat': lat, 'userlong': lng});

    return result;
  }

  Future<Map> getAPMDetails(String apmid) async {
    print("TARGET APMID = $apmid");
    var resultAPM = await supabase.from('apms').select('''
          apmid,
          printername,
          pictureurl,
          picture_url_2,
          apmaddresses (address1, address2, city, state, lat, lng),
          apmdetails (type, bwprint, colorprint, bothsideprint, papersize,layout),
          operatinghours (monday, tuesday, wednesday, thursday, friday, saturday, sunday)
          ''').match({'apmid': apmid}).single();
    print("RESULTAPM = $resultAPM");
    return resultAPM;
  }

  Future<Map<String, dynamic>> getAPMCost(String apmID) async {
    var data = await supabase
        .from('apm_costs')
        .select('*')
        .eq('apmid', apmID)
        .single();

    return data;
  }
}
