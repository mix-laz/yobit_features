import 'package:flutter/material.dart';
import 'User.dart';
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
  List<double> fiat_balancies=[];

  @override
  void initState() {
    users = User.getUsers();
    currencyController.text = 'kbc';
    amountController.text = '4897';
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
                          //depth json to object
                          DepthPairs depthPairs =
                              new DepthPairs(json.decode(snapshot.data));

                          List<CalcPair> quoted_balancies = generateQuotedList(
                              double.parse(amountController.text),
                              depthPairs.listPairs);

                          Future<DepthPairs> depthFiatPairs =
                              fetchDepthFiatPairs(given_fiat);
                          depthFiatPairs.then((DepthPairs value) {
                             fiat_balancies = generateFiatList(
                                quoted_balancies, value.listPairs);
                          }, onError: (e) {
                            print(e);
                          });
//
                          //
                          return Column(
                            children: <Widget>[dataBody(fiat_balancies)],
                          );
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

  SingleChildScrollView dataBody(List<double> balances) {
    balances.insert(0, 0);
    print('balances = '+balances.toString());
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
          rows: <DataRow>[
         //   DataCell(Text('')),
           DataRow(cells:  balances.map(
                   (cost)=>{DataCell(Text(cost.toStringAsFixed(1)))}).toList().cast<DataCell>() )

          ],
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

  List<double> generateFiatList(
    List<CalcPair> calc_pair_list, List<Pair> depth_fiat_list) {
    print('calc_pair_list: '+calc_pair_list.toString());

    List<double> revenue_list = [];
    int i = 0;

      //---------------------------------------------
//    calc_pair_list.forEach((CalcPair calc_pair) {
//      if(calc_pair.quoted_currency==given_fiat) {
//        revenue_list.add(calc_pair.cost);
//      }else {
//        Pair pair = getApropriatePair(calc_pair, depth_fiat_list);
//        if(pair==null){
//          revenue_list.add(0.00);
//        }else{
//          List<dynamic> bids = pair.bids;
//          double revenue = sellCurrency(bids, calc_pair.cost);
//          revenue_list.add(revenue);
//        }
//       // print('next_bids =  ' + bids.toString());
//
//
//        print('i = : $i');
//
//        i++;
//      }
//    });

    //---------------------------------------------
    depth_fiat_list.forEach((Pair depth_pair) {

        CalcPair calc_pair = getApropriatePair(depth_pair, calc_pair_list);
        if (calc_pair == null) {
          revenue_list.add(0.00);
        }else if(calc_pair.quoted_currency==given_fiat){
          revenue_list.add(calc_pair.cost);
        }else {
          List<dynamic> bids = depth_pair.bids;
          double revenue = sellCurrency(bids, calc_pair.cost);
          revenue_list.add(revenue);
        }
        // print('next_bids =  ' + bids.toString());


        print('i = : $i');
        i++;



    });
    print('revenue_list =  ' + revenue_list.toString());
    return revenue_list;
  }

  //get matching depth pair
  CalcPair getApropriatePair(Pair depth_pair, List<CalcPair> calc_pair_list) {

    for (CalcPair next_calc_pair in calc_pair_list) {
     // print('calcPair.quoted_currency =  ' + calcPair.quoted_currency.toString());

      if (depth_pair.name.contains(next_calc_pair.quoted_currency)) {
        return next_calc_pair;
      }
    }
    return null;
  }

  //get resuld list of solding given currency  into  btc,eth,yo,doge,waves,rur,usd
  List<CalcPair> generateQuotedList(double b, List<Pair> list) {
    List<CalcPair> quoted_balancies = [];

    // iterate pairs
    for (int i = 0; i < list.length; i++) {
      Pair next_pair = list[i];
      List<dynamic> bids = next_pair.bids;
      //  print('bids =  '+bids.toString() );
      double base_currency_amount = b;
      //  print('bids.length: '+bids.length.toString());
      double next_cost = sellCurrency(bids, base_currency_amount);
      quoted_balancies.add(new CalcPair(next_pair.name.substring(next_pair.name.indexOf('_')+1), next_cost));

    }
    print('quoted_balancies: $quoted_balancies');

    return quoted_balancies;
  }

  double sellCurrency(List bids, double ca) {
    double final_cost = 0.0;
    double currency_amount = ca;

    // iterate bids of pair
    for (int j = 0; j < bids.length; j++) {
      var next_order = bids[j][0];
      var next_amount = bids[j][1];
      //  print('next_bid: $bids[j]');
      //  print('next_base_balance: $base_balance');
      //  print('base_balance-next_amount:'+ (base_balance-next_amount).toString());

      if (currency_amount > next_amount) {
        final_cost = final_cost + next_order * next_amount;
        currency_amount = currency_amount - next_amount;
        //  print('next_quoted_balance: $quoted_balance');

      } else {
        final_cost = final_cost + currency_amount * next_order;

        //base_balance = base_balance - next_amount;
        print('final_cost: $final_cost');

        break;
      }
    }
    return final_cost;
  }

  //fetch depth(btc,eth,yo,doge,etc...) for given fiat
  Future<DepthPairs> fetchDepthFiatPairs(String quoted_fiat) async {
    String url = inicializeDepthFiathUrl(quoted_fiat);
    print('FiathUrl: ' + url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //  print('json.decode(json.decode(response.body): '+response.body);

      DepthPairs depthFiatCost = new DepthPairs(json.decode(response.body));
      return depthFiatCost;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load FiatCoinsList');
    }
  }
}

class CalcPair {
  String quoted_currency;
  double cost;

  CalcPair(this.quoted_currency, this.cost);

  @override
  String toString() {
    return 'CalcPair{quoted_currency: $quoted_currency, cost: $cost}';
  }


}
