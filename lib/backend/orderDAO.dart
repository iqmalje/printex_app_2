import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:path/path.dart';

class OrderDAO {
  SupabaseClient supabase = Supabase.instance.client;
  Future<List<dynamic>> getOrdersByAccounts() async {
    //fetch orders based on userid
    List<dynamic> orders = await supabase.from('orders').select('''
      orderid,
      accountid,
      fileid,
      apmid,
      cost,
      status,
      date,
      files:fileid (filename, pagecount),
      settings (pagepersheet),
      target_apm

''').order('date', ascending: false);

    for (var order in orders) {
      //get url
      var url = supabase.storage
          .from('files')
          .getPublicUrl('${order['fileid']}/${order['files']['filename']}');

      order['fileurl'] = url;
      order['coverimage'] = supabase.storage
          .from('files')
          .getPublicUrl('${order['fileid']}/coverimage.png');
      order['date'] =
          DateTime.parse(order['date']).add(const Duration(hours: 8));
    }

    //now insert fileurl into it

    return orders;
  }

  Future<Map> fetchOrderSettings(String orderid) async {
    /*
      settings: {
        'layout': layout,
        'color': color,
        'side': side,
        'pagepersheet': pagepersheet,
        'copies': copiesInt,
        'pages': pagesSetting,
        'pagecount': pagecount,
        'range': range.text
      },
    */

    var result =
        await supabase.from('settings').select('*').match({'orderid': orderid});

    var resultReturn = result[0];
    return {
      'layout': resultReturn['layout'],
      'color': resultReturn['color'],
      'side': resultReturn['side'],
      'pagepersheet': resultReturn['pagepersheet'],
      'copies': resultReturn['copies'],
      'pages': resultReturn['pages'],
    };
  }

  Future<Map<String, dynamic>> getCosts() async {
    var data = await supabase.from('COST').select('*').single();

    return data;
  }

  Future<String> getCoverImageUrl(String fileID) async {
    var url =
        supabase.storage.from('files').getPublicUrl('$fileID/coverimage.png');

    return url;
  }

  Future<void> deleteOrderLive(String orderid, String fileid) async {
    // delete storage
    try {
      await supabase.storage.from('files').remove([
        '$fileid/print.pdf',
        '$fileid/print.png',
        '$fileid/print.jpg',
        '$fileid/print.jpeg',
        '$fileid/coverimage.png'
      ]);

      await supabase.from('orders').delete().eq('orderid', orderid);
      print('DAH DELETE');
    } catch (e) {
      print(e);
    }
  }

  Future<String> createOrder(
      String fileID, double cost, String filename, String apmID) async {
    String userid = supabase.auth.currentUser!.id;

    var orderResponse = await supabase.from('orders').insert({
      'accountid': userid,
      'fileid': fileID,
      'cost': cost,
      'apmid': apmID
    }).select();

    await supabase.from('transactions').insert({
      'accountid': userid,
      'type': 'ORDER',
      'amount': cost,
      'orderid': orderResponse[0]['orderid'],
      'filename': filename
    });

    return orderResponse[0]['orderid'];
  }

  Future<String> uploadFile(
      File file, String filename, int pagecount, Uint8List coverBytes) async {
    //store information regarding file such as name and page count to table and upload to bucket
    String userid = supabase.auth.currentUser!.id;

    filename = filename.replaceAll("[", "(");
    filename = filename.replaceAll("]", ")");
    filename = filename.replaceAll("*", "");
    filename = filename.replaceAll(";", "");

    List<Map<String, dynamic>> fileResult = await supabase
        .from('files')
        .insert({
      'accountid': userid,
      'filename': filename,
      'pagecount': pagecount
    }).select();

    String fileID = fileResult[0]['fileid'];

    //uploads to bucket containing file

    await supabase.storage
        .from('files')
        .upload('$fileID/print${extension(file.path).toLowerCase()}', file);
    await supabase.storage
        .from('files')
        .uploadBinary('$fileID/coverimage.png', coverBytes);

    return fileID;
  }

  Future<void> createSettings(String orderID, String layout, String color,
      String side, String pagepersheet, int copies, String pages) async {
    var userid = supabase.auth.currentUser!.id;
    await supabase.from('settings').insert({
      'orderid': orderID,
      'accountid': userid,
      'layout': layout,
      'color': color,
      'side': side,
      'pagepersheet': pagepersheet,
      'copies': copies,
      'pages': pages
    });
  }

  Future<PdfDocument> downloadFile(String fileid) async {
    HttpClient client = HttpClient();
    var data = supabase.storage.from('files').getPublicUrl('$fileid/print.pdf');
    var request = await client.getUrl(Uri.parse(data));
    var response = await request.close();

    var bytes = await consolidateHttpClientResponseBytes(response);

    return await PdfDocument.openData(bytes);
  }
}
