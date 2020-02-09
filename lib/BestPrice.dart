import 'package:flutter/material.dart';
import 'User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yobit_features/TopCoinsCost.dart';

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

  @override
  void initState() {
    users = User.getUsers();
    currencyController.text = 'kbc';
    amountController.text = '5238';
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
            Expanded(
              child: dataBody(),
            ),
            new Text(
              '',
              style: TextStyle(color: Colors.red),
            ),
            Container(
              height: 100,
              child: FutureBuilder(
                  future: base_url != null
                      ? http
                      .get(base_url.toString())
                      .then((response) => response.body)
                      : null,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return new Center(
                            child: new CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return new Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          );
                        } else if (snapshot.hasData) {
                          TopCoinsCost topCoinsCost =
                          new TopCoinsCost(json.decode(snapshot.data));
                          List<double> quoted_balancies = generateQuotedList(
                              double.parse(amountController.text),
                              topCoinsCost.listPairs);
                          ListView tempList = ListView.builder(
                              itemCount: quoted_balancies == null
                                  ? 0
                                  : quoted_balancies.length,
                              itemBuilder: (BuildContext context, int index) {
                                return new ListTile(
                                  title: Text(
                                      quoted_balancies[index].toString(),
                                      style: TextStyle(color: Colors.black)),

                                );
                              });
                          //
                          return tempList;
                          // return   new Text( '${topCoinsCost.listPairs.toString()}', style: TextStyle(color: Colors.black),                          );

                              ;
                        }
                    } //switch
                  }),
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
                  transformCoinToFiat(
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

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columnSpacing: 0.5,
          columns: <DataColumn>[
            DataColumn(
                label: Text('NAME', style: TextStyle(fontSize: font_size_clm))),
            DataColumn(
                label: Text('BTC', style: TextStyle(fontSize: font_size_clm))),
            DataColumn(
                label: Text('ETH', style: TextStyle(fontSize: font_size_clm))),
            DataColumn(
                label: Text('DOGE', style: TextStyle(fontSize: font_size_clm))),
            DataColumn(
                label: Text('YO', style: TextStyle(fontSize: font_size_clm))),
            DataColumn(
                label:
                Text('WAVES', style: TextStyle(fontSize: font_size_clm))),
            DataColumn(
                label: Text('USD', style: TextStyle(fontSize: font_size_clm))),
            DataColumn(
                label: Text('RUR', style: TextStyle(fontSize: font_size_clm)))
          ],
          rows: users
              .map((User) =>
              DataRow(cells: [
                DataCell(Text('')),
                DataCell(Text(User.firstName,
                    style: TextStyle(fontSize: font_size_row))),
                DataCell(Text(User.lastName,
                    style: TextStyle(fontSize: font_size_row))),
                DataCell(Text(User.firstName,
                    style: TextStyle(fontSize: font_size_row))),
                DataCell(Text(User.firstName,
                    style: TextStyle(fontSize: font_size_row))),
                DataCell(Text(User.firstName,
                    style: TextStyle(fontSize: font_size_row))),
                DataCell(Text(User.firstName,
                    style: TextStyle(fontSize: font_size_row))),
                DataCell(Text(User.firstName,
                    style: TextStyle(fontSize: font_size_row)))
              ]))
              .toList()),
    );
  }

  Widget transformCoinToFiat(String curr, String amount, String price) {
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
        "&limit=2"
      ]);
    });
  }

  List generateQuotedList(double b, List<Pair> list) {
    double base_balance = b;
    List quoted_balancies = [];

    for (int i = 0; i < list.length; i++) {
      print('quoted_balancies $i: $quoted_balancies');

      Pair next_pair = list.elementAt(i);
      List<Bid> bids = next_pair.bids.cast<Bid>();
      //List<Bid> cast = bids.cast<Bid>();
      double quoted_balance;
      print('quoted_balancies: $quoted_balancies');
      print('bids: ');

      for (int j = 0; j < bids.length; j++) {
        var next_order = bids.elementAt(j);
        print('next_order: $next_order');
        if (base_balance > next_order.amount) {
          quoted_balance =
              quoted_balance + next_order.amount * next_order.price;
        } else {
          quoted_balance = quoted_balance + base_balance * next_order.price;
          quoted_balancies.add(quoted_balance);
          break;
        }
        base_balance = base_balance - next_order.amount;
        print('base_balance: $base_balance');
      }
    }
    return quoted_balancies;
  }
}
