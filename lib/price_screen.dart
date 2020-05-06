import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency;
  Map<String, CoinData> dataList = Map();

  DropdownButton<String> _androidDropdown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList
          .map((currency) =>
              DropdownMenuItem(child: Text(currency), value: currency))
          .toList(),
      onChanged: _updateUI,
    );
  }

  CupertinoPicker _iOSPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex) =>
          _updateUI(currenciesList[selectedIndex]),
      children: currenciesList.map((currency) => Text(currency)).toList(),
    );
  }

  Widget _changeCard(String baseCurrency) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $baseCurrency = ${dataList[baseCurrency]?.rate?.toStringAsFixed(2) ?? '?'} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _updateUI(String currency) {
    setState(() => dataList.clear());
    Future.wait(cryptoList.map(
      (base) => CoinData.getFromAPI(base: base, quote: currency),
    )).then((coinDataList) => setState(() {
          selectedCurrency = currency;
          dataList = Map.fromEntries(coinDataList.map(
            (coinData) => MapEntry(coinData.assetIdBase, coinData),
          ));
        }));
  }

  @override
  void initState() {
    super.initState();
    _updateUI(currenciesList.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList.map(_changeCard).toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? _iOSPicker() : _androidDropdown(),
          ),
        ],
      ),
    );
  }
}
