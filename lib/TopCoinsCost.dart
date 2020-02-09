class TopCoinsCost {
  List<Pair> listPairs;
  List _listPNames = [];

  TopCoinsCost(Map<String, dynamic> json) {
    listPairs = jsonToObj(json);
  }

  List jsonToObj(Map<String, dynamic> json) {
    json.keys.forEach((key) => {_listPNames.add(key)});
    print(_listPNames);

    List<Pair> _tmp = [];

    for (int i = 0; i < _listPNames.length; i++) {
      final Pair pair = new Pair(
        pair: _listPNames[i],
        asks: json[_listPNames[i]]['asks'],
        bids: json[_listPNames[i]]['bids'],
      );
      print('next Pair:' + pair.toString());

      _tmp.add(pair);
    }

    return _tmp;
  }
}

class Pair {
  String pair;
  List asks = <Ask>[];
  List bids = <Bid>[];

  Pair({this.pair, this.bids, this.asks});

  @override
  String toString() {
    return 'Pair{pair: $pair, asks: $asks, bids: $bids}';
  }
}

class Ask {
  double _price;
  double _amount;

  double get price => _price;

  double get amount => _amount;

  @override
  String toString() {
    return 'Ask{_price: $_price, _amount: $_amount}';
  }
}

class Bid {
  double _price;
  double _amount;

  double get price => _price;

  double get amount => _amount;

  @override
  String toString() {
    return 'Ask{_price: $_price, _amount: $_amount}';
  }
}
