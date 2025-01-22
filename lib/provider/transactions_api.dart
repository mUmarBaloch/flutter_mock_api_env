import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_shop_admin/provider/core/api.dart';
import 'package:smart_shop_admin/provider/shared_pref.dart';

import '../model/transaction_model.dart';

class TransactionsApiService {
  String token = SharedPref().token.toString();


 fetchTransactions()async{
    try{
    Uri url = Uri.parse(Api.baseUrl+Api.transactionEndPoint);
    final response = await http.get(url,headers:Api.headers(token));
    if(response.statusCode == 200){
    final List<Map<String, dynamic>> _decodedTransactions = json.decode(response.body);
    final result = _decodedTransactions.map((transaction)=>Transaction.fromJson(transaction)).toList();
    return result;
    }
    }
    on SocketException
    {throw 'internet issue';}
    catch (e) {
      throw 'Exception : $e';
    }
  }

}