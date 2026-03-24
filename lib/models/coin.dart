class Coin {
  String name;
  double amount;
  double price;
  bool isFavorite;
  String symbol;

  Coin({
    required this.name,
    required this.amount,
    required this.price,
    this.isFavorite = false,
    required this.symbol,
  });

  double get totalValue => amount * price;
}
