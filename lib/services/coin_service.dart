import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinService {

  Future<Map<String, dynamic>> getCoinData() async {

    final response = await http.get(
      Uri.parse(
        "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,tether&vs_currencies=usd",
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load prices");
    }
  }

  Future<double> getCoinPrice(String coin) async {

    final data = await getCoinData();

    switch (coin.toLowerCase()) {

      case "btc":
        return (data["bitcoin"]["usd"]).toDouble();

      case "eth":
        return (data["ethereum"]["usd"]).toDouble();

      case "usdt":
        return (data["tether"]["usd"]).toDouble();

      default:
        return 0;
    }
  }
}