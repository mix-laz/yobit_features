import 'Pair.dart';
import 'QuotedBalance.dart';

class FiatBalance {
  double _btc=0.0;
  double _eth=0.0;
  double _doge=0.0;
  double _yo=0.0;
  double _waves=0.0;
  double _usd=0.0;
  double _rur=0.0;


  @override
  String toString() {
    return 'FiatBalance{_btc: $_btc, _eth: $_eth, _doge: $_doge, _yo: $_yo, _waves: $_waves, _usd: $_usd, _rur: $_rur}';
  }

  FiatBalance();

  factory FiatBalance.fromFiatPairs(QuotedBalance quotedBalance,List<Pair> list) {//,String givenFiat

    FiatBalance fiatBalance = new FiatBalance();
    fiatBalance.usd=quotedBalance.usd;


    // iterate pairs
    for (Pair next_pair  in list ) {
      List<dynamic> bids = next_pair.bids;
      List<dynamic> asks = next_pair.asks;
      double base_amount = 0.0;
      if(next_pair.name.contains('btc')){
        base_amount=quotedBalance.btc;
      }else if(next_pair.name.contains('eth')){
        base_amount=quotedBalance.eth;
      }else if(next_pair.name.contains('doge')){
        base_amount=quotedBalance.doge;
      }else if(next_pair.name.contains('yo')){
        base_amount=quotedBalance.yo;
      }else if(next_pair.name.contains('waves')){
        base_amount=quotedBalance.waves;
      }else if(next_pair.name.contains('rur')){
        base_amount=quotedBalance.rur;
      }
    //================= selling currency ===============


      double next_fiat = 0.0;

      // iterate bids of pair
      for (int j = 0; j < bids.length; j++) {
        var next_price = bids[j][0];
        var next_amount = bids[j][1];

        //specific logic of converting rur to usd
        if (next_pair.name.contains('rur')) {
          var next_price = asks[j][0];
          var next_amount = asks[j][1];
          if (base_amount > next_amount) {
            next_fiat = next_fiat + next_amount / next_price;
            base_amount = base_amount - next_amount;
            print('next_fiat rur: $next_fiat');
          } else {
            next_fiat = next_fiat + base_amount / next_price;

            //base_balance = base_balance - next_amount;

            break;
          }

        } else {
          //ussual logic of converting  to usd
        if (base_amount > next_amount) {
          next_fiat = next_fiat + next_price * next_amount;
          base_amount = base_amount - next_amount;
        } else {
          next_fiat = next_fiat + base_amount * next_price;

          //base_balance = base_balance - next_amount;
          //   print('final_cost: $next_fiat');

          break;
        }
      }
      }
      //================= selling currency ===============//


      if(next_pair.name.contains('btc')){
        fiatBalance.btc=next_fiat;
      }else if(next_pair.name.contains('eth')){
        fiatBalance.eth=next_fiat;
      }else if(next_pair.name.contains('doge')){
        fiatBalance.doge=next_fiat;
      }else if(next_pair.name.contains('yo')){
        fiatBalance.yo=next_fiat;
      }else if(next_pair.name.contains('waves')){
        fiatBalance.waves=next_fiat;
      }else if(next_pair.name.contains('rur')){
        fiatBalance.rur=next_fiat;
      }
    }
    return fiatBalance;
  }

  double get rur => _rur;

  set rur(double value) {
    _rur = value;
  }

  double get usd => _usd;

  set usd(double value) {
    _usd = value;
  }

  double get waves => _waves;

  set waves(double value) {
    _waves = value;
  }

  double get yo => _yo;

  set yo(double value) {
    _yo = value;
  }

  double get doge => _doge;

  set doge(double value) {
    _doge = value;
  }

  double get eth => _eth;

  set eth(double value) {
    _eth = value;
  }

  double get btc => _btc;

  set btc(double value) {
    _btc = value;
  }

}
