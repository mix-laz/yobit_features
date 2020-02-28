import 'Pair.dart';

class QuotedBalance {
  double _btc=0.0;
  double _eth=0.0;
  double _doge=0.0;
  double _yo=0.0;
  double _waves=0.0;
  double _usd=0.0;
  double _rur=0.0;


  @override
  String toString() {
    return 'QuotedBalance{_btc: $_btc, _eth: $_eth, _doge: $_doge, _yo: $_yo, _waves: $_waves, _usd: $_usd, _rur: $_rur}';
  }

  QuotedBalance();

  factory QuotedBalance.fromPairs(double b_amount, List<Pair> list) {

    QuotedBalance quotedBalance = new QuotedBalance();

    // iterate pairs
    for (Pair next_pair  in list ) {
      List<dynamic> bids = next_pair.bids;
      double base_amount = b_amount;
      //================= selling currency ===============

      double next_quoted = 0.0;

      // iterate bids of pair
      for (int j = 0; j < bids.length; j++) {
        var next_price = bids[j][0];
        var next_amount = bids[j][1];


        if (base_amount > next_amount) {
          next_quoted = next_quoted + next_price * next_amount;
          base_amount = base_amount - next_amount;
          //  print('next_quoted_balance: $quoted_balance');

        } else {
          next_quoted = next_quoted + base_amount * next_price;


          break;
        }
      }
      //================= selling currency ===============//


      if(next_pair.name.contains('_btc')){
        quotedBalance.btc=next_quoted;
      }else if(next_pair.name.contains('_eth')){
        quotedBalance.eth=next_quoted;
      }else if(next_pair.name.contains('_doge')){
        quotedBalance.doge=next_quoted;
      }else if(next_pair.name.contains('_yo')){
        quotedBalance.yo=next_quoted;
      }else if(next_pair.name.contains('_waves')){
        quotedBalance.waves=next_quoted;
      }else if(next_pair.name.contains('_usd')){
        quotedBalance.usd=next_quoted;
      }else if(next_pair.name.contains('_rur')){
        quotedBalance.rur=next_quoted;
      }
    }
    return quotedBalance;
  }


  double get btc => _btc;

  set btc(double value) {
    _btc = value;
  }

  double get eth => _eth;

  set eth(double value) {
    _eth = value;
  }

  double get doge => _doge;

  set doge(double value) {
    _doge = value;
  }

  double get yo => _yo;

  set yo(double value) {
    _yo = value;
  }

  double get waves => _waves;

  set waves(double value) {
    _waves = value;
  }

  double get usd => _usd;

  set usd(double value) {
    _usd = value;
  }

  double get rur => _rur;

  set rur(double value) {
    _rur = value;
  }
}
