import 'package:flutter/material.dart';
import 'User.dart';
import 'Pair.dart';
import 'QuotedBalance.dart';
import 'FiatBalance.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yobit_features/DepthPairs.dart';

class BestPrice extends StatefulWidget {
  @override
  _BestPriceState createState() => _BestPriceState();
}

class _BestPriceState extends State<BestPrice> {
  List<User> users;
  final currencyController = TextEditingController();
  final amountController = TextEditingController();
  final priceController = TextEditingController();
  final double font_size_clm = 10;
  final double font_size_row = 10;
  StringBuffer base_url = null;
  String given_fiat = 'usd';
  List<double> fiat_balancies = [];

  @override
  void initState() {
    users = User.getUsers();
    currencyController.text = 'alisa';
    amountController.text = '4500';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Продажа'),
      ),
      body: Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            new Text(
              '',
              style: TextStyle(color: Colors.red),
            ),
            Expanded(
                child: new FutureBuilder(
                    future: drawFullTable(given_fiat),
                    initialData: new FiatBalance(),
                    // ignore: missing_return
                    builder: (BuildContext context,AsyncSnapshot<FiatBalance> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return new Text(
                            '${'connection none'}',
                            style: TextStyle(color: Colors.red),
                          );
                        case ConnectionState.waiting:
                          return new Center(
                              child: new CircularProgressIndicator());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return new Text(
                              '',
                              style: TextStyle(color: Colors.red),
                            );
                          } else if (snapshot.hasData) {
                            return new SingleChildScrollView(
                              child: Column(
                                children: <Widget>[dataBody(snapshot.data)],
                              ),
                            );

                          }

                    }

                    })

            ),
            TextField(
              controller: currencyController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'коин...'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'количество...'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'цена...'),
            ),
            FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  inicializeDepthUrl(
                    currencyController.text,
                    amountController.text,
                    priceController.text,
                  );
                },
                child: Text("Рассчитать", style: TextStyle(fontSize: 25.0)))
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataBody(FiatBalance fiatBalance) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columnSpacing: 0.5,
            columns: <DataColumn>[
              DataColumn(
                  label: Text(
                      'NAME', style: TextStyle(fontSize: font_size_clm))),
              DataColumn(
                  label: Text(
                      'BTC', style: TextStyle(fontSize: font_size_clm))),
              DataColumn(
                  label: Text(
                      'ETH', style: TextStyle(fontSize: font_size_clm))),
              DataColumn(
                  label: Text(
                      'DOGE', style: TextStyle(fontSize: font_size_clm))),
              DataColumn(
                  label: Text('YO', style: TextStyle(fontSize: font_size_clm))),
              DataColumn(
                  label:
                  Text('WAVES', style: TextStyle(fontSize: font_size_clm))),
              DataColumn(
                  label: Text(
                      'USD', style: TextStyle(fontSize: font_size_clm))),
              DataColumn(
                  label: Text('RUR', style: TextStyle(fontSize: font_size_clm)))
            ],
            rows: <DataRow>[
              DataRow(cells: [
                DataCell(Text('')),
                DataCell(Text(fiatBalance.btc.toStringAsFixed(1))),
                DataCell(Text(fiatBalance.eth.toStringAsFixed(1))),
                DataCell(Text(fiatBalance.doge.toStringAsFixed(1))),
                DataCell(Text(fiatBalance.yo.toStringAsFixed(1))),
                DataCell(Text(fiatBalance.waves.toStringAsFixed(1))),
                DataCell(Text(fiatBalance.usd.toStringAsFixed(1))),
                DataCell(Text(fiatBalance.rur.toStringAsFixed(1))),
              ])
            ]
        )
    );
  }

  inicializeDepthUrl(String curr, String amount, String price) {
    base_url = new StringBuffer("https://yobit.net/api/3/depth/");
    setState(() {
      base_url.writeAll([
        curr,
        "_",
        "btc",
        "-",
        curr,
        "_",
        "eth",
        "-",
        curr,
        "_",
        "doge",
        "-",
        curr,
        "_",
        "yo",
        "-",
        curr,
        "_",
        "waves",
        "-",
        curr,
        "_",
        "usd",
        "-",
        curr,
        "_",
        "rur",
        "?ignore_invalid=1",
        "&limit=2000"
      ]);
    });
  }

  String inicializeDepthFiathUrl(String quoted_fiat) {
    StringBuffer quoted_fiat_url =
    new StringBuffer("https://yobit.net/api/3/depth/");
    quoted_fiat_url.writeAll([
      'btc',
      "_",
      quoted_fiat,
      "-",
      'eth',
      "_",
      quoted_fiat,
      "-",
      'doge',
      "_",
      quoted_fiat,
      "-",
      'yo',
      "_",
      quoted_fiat,
      "-",
      'waves',
      "_",
      quoted_fiat,
      "-",
      quoted_fiat,
      "_",
      "rur",
      "?ignore_invalid=1",
      "&limit=2000"
    ]);
    return quoted_fiat_url.toString();
  }


  //fetch depth(btc,eth,yo,doge,etc...) for given fiat
  Future<DepthPairs> fetchDepthFiatPairs(String quoted_fiat) async {
    String url = inicializeDepthFiathUrl(quoted_fiat);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      DepthPairs depthFiatCost = new DepthPairs(json.decode(response.body));
      return depthFiatCost;
    } else {
      throw Exception('Failed to load FiatCoinsList');
    }
  }

  Future<FiatBalance> drawFullTable(String given_fiat) async {
    final q_response = await http.get(base_url.toString());
    if (q_response.statusCode == 200) {
      DepthPairs depthPairs = new DepthPairs(
          json.decode(q_response.body));
      QuotedBalance quotedBalance = QuotedBalance.fromPairs(
          double.parse(amountController.text), depthPairs.listPairs);
      print(quotedBalance.toString());
      //================================================

      String url = inicializeDepthFiathUrl(given_fiat);

      final f_response = await http.get(url);
      if (f_response.statusCode == 200) {
        DepthPairs fiatPairs = new DepthPairs(
            json.decode(f_response.body));
        FiatBalance fiatBalance = FiatBalance.fromFiatPairs(quotedBalance,
            fiatPairs.listPairs);
        print(fiatBalance.toString());
       return new Future<FiatBalance>(()=>
         FiatBalance.fromFiatPairs(quotedBalance,fiatPairs.listPairs));
      } else {
        throw Exception('Failed to load FiatCoinsList');
      }
    } else {
      throw Exception('Failed to load FiatCoinsList');
    }
  }

}

