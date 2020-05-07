import 'dart:async';
import 'dart:convert';

import 'package:bitcoin_ticker/generated/json/base/json_convert_content.dart';
import 'package:bitcoin_ticker/generated/json/base/json_filed.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String coinAPIKey = '902D9E47-F9F2-476D-A3E5-CD34138F911A';
const String coinAPIUrl = 'https://rest.coinapi.io';

class CoinData with JsonConvert<CoinData> {
  String time;
  @JSONField(name: "asset_id_base")
  String assetIdBase;
  @JSONField(name: "asset_id_quote")
  String assetIdQuote;
  double rate;

  static Future<CoinData> getFromAPI({String base, String quote}) async {
    http.Response response = await http.get(
      '$coinAPIUrl/v1/exchangerate/$base/$quote',
      headers: {'X-CoinAPI-Key': coinAPIKey},
    );
    if (response.statusCode >= 300) {
      throw Exception('Hu Oh ! Error #${response.statusCode}');
    }
    return CoinData().fromJson(jsonDecode(response.body));
  }

  static Future<Map<String, CoinData>> getAllFromAPI(String quote) async {
    List<CoinData> list = await Future.wait(cryptoList.map(
      (base) => CoinData.getFromAPI(base: base, quote: quote),
    ));
    return Map.fromEntries(
      list.map((coinData) => MapEntry(coinData.assetIdBase, coinData)),
    );
  }
}
