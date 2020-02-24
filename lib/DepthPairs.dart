class DepthPairs {
  List<Pair> listPairs;
  List _listPNames = [];

  DepthPairs(Map<String, dynamic> json) {
    listPairs = jsonToObj(json);
  }

  List<Pair> jsonToObj(Map<String, dynamic> json) {
    json.keys.forEach((key) => {
      _listPNames.add(key ),

    });
    print(_listPNames);

    List<Pair> _tmp = [];

    for (int i = 0; i < _listPNames.length; i++) {
      final Pair pair = new Pair(
        name: _listPNames[i],
        asks: json[_listPNames[i]]['asks']  ,
        bids: json[_listPNames[i]]['bids']  ,
      );
      //print('next Pair:' + pair.toString());

      _tmp.add(pair);
    }

    return _tmp;
  }
}

class Pair {
  String name;
  var asks = [];
  var bids = [];

  Pair({this.name, this.bids, this.asks});

  @override
  String toString() {
    return 'Pair{pair: $name, asks: $asks, bids: $bids}';
  }
}

