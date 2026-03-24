import 'package:flutter/material.dart';
import '../models/coin.dart';

class CoinTile extends StatelessWidget {
  final Coin coin;

  CoinTile({required this.coin});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(coin.name),
      subtitle: Text("Amount: ${coin.amount}"),
      trailing: Text("\$${coin.price}"),
    );
  }
}