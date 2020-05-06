import 'package:bitcoin_ticker/coin_data.dart';

exchangeRateEntityFromJson(CoinData data, Map<String, dynamic> json) {
  if (json['time'] != null) {
    data.time = json['time']?.toString();
  }
  if (json['asset_id_base'] != null) {
    data.assetIdBase = json['asset_id_base']?.toString();
  }
  if (json['asset_id_quote'] != null) {
    data.assetIdQuote = json['asset_id_quote']?.toString();
  }
  if (json['rate'] != null) {
    data.rate = json['rate']?.toDouble();
  }
  return data;
}

Map<String, dynamic> exchangeRateEntityToJson(CoinData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['time'] = entity.time;
  data['asset_id_base'] = entity.assetIdBase;
  data['asset_id_quote'] = entity.assetIdQuote;
  data['rate'] = entity.rate;
  return data;
}
