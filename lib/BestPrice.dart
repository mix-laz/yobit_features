import 'package:flutter/material.dart';
import 'User.dart';

class BestPrice extends StatefulWidget {
  @override
  _BestPriceState createState() => _BestPriceState();
}

class _BestPriceState extends State<BestPrice> {
  List<User> users;

  @override
  void initState() {
    users = User.getUsers();
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
              ],
            ),
          ),
        );
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(label: Text('NAME')),
          DataColumn(label: Text('BTC')),
          DataColumn(label: Text('ETH')),
          DataColumn(label: Text('DOGE')),
          DataColumn(label: Text('YO')),
          DataColumn(label: Text('WAVES')),
          DataColumn(label: Text('USD')),
          DataColumn(label: Text('RUR'))
        ],
        rows: users.map((User)=>
          DataRow(cells: [
            DataCell(Text('')),
            DataCell(Text(User.firstName)),
            DataCell(Text(User.lastName)),
            DataCell(Text(User.firstName)),
            DataCell(Text(User.firstName)),
            DataCell(Text(User.firstName)),
            DataCell(Text(User.firstName)),
            DataCell(Text(User.firstName))

          ])
        ).toList()
      ),
    );
  }
}

