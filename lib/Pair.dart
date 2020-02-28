
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