import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class CoinApiService {

  Future<Map<String, dynamic>> fetchCoins() async {

    final url = Uri.parse(
      "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,tether,solana,binancecoin,dogecoin&vs_currencies=usd",
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    return {
      "BTC": data["bitcoin"]["usd"].toDouble(),
      "ETH": data["ethereum"]["usd"].toDouble(),
      "USDT": data["tether"]["usd"].toDouble(),
      "SOL": data["solana"]["usd"].toDouble(),
      "BNB": data["binancecoin"]["usd"].toDouble(),
      "DOGE": data["dogecoin"]["usd"].toDouble(),
    };
  }

  List<double> generatePrediction(
      double currentPrice,
      ) {

    final random = Random();

    List<double> values = [];

    double price = currentPrice;

    for (int i = 0; i < 12; i++) {

      double change =
          random.nextDouble() * 0.12;

      bool increase =
      random.nextBool();

      if (increase) {
        price += price * change;
      } else {
        price -= price * change;
      }

      values.add(price);
    }

    return values;
  }
}