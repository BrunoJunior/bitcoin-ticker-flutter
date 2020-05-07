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
  Map<String, CoinData> dataList = {};

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
    CoinData dataCoin = dataList[baseCurrency] ?? CoinData()
      ..assetIdBase = baseCurrency
      ..assetIdQuote = selectedCurrency;
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: ChangeCard(dataCoin),
    );
  }

  void _updateUI(String currency) async {
    setState(() => dataList.clear());
    Map<String, CoinData> data = await CoinData.getAllFromAPI(currency);
    setState(() {
      selectedCurrency = currency;
      dataList = data;
    });
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

class ChangeCard extends StatelessWidget {
  final CoinData dataCoin;
  ChangeCard(this.dataCoin);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 ${dataCoin.assetIdBase} = ${dataCoin.rate?.toStringAsFixed(2) ?? '?'} ${dataCoin.assetIdQuote}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
