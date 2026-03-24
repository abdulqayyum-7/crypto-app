import '../models/coin.dart';
import '../models/transaction.dart';
import '../models/user_profile.dart';

Map<String, String> userData = {};

UserProfile currentUser = UserProfile(
  name: "Abdul Qayyum",
  email: "user@example.com",
);

List<Coin> coins = [
  Coin(name: "Bitcoin", symbol: "BTC", amount: 0.5, price: 50000, isFavorite: true),
  Coin(name: "Ethereum", symbol: "ETH", amount: 2.0, price: 3000),
  Coin(name: "Tether", symbol: "USDT", amount: 1200, price: 1),
  Coin(name: "BNB", symbol: "BNB", amount: 5, price: 420),
  Coin(name: "Solana", symbol: "SOL", amount: 10, price: 110),
  Coin(name: "XRP", symbol: "XRP", amount: 800, price: 0.62),
];

List<TransactionModel> transactions = [
  TransactionModel(
    type: "receive",
    amount: 0.12,
    address: "0xABCD1234EFGH5678",
    date: "24 Mar 2026",
    time: "10:30 AM",
    status: "Completed",
    coinName: "BTC",
  ),
  TransactionModel(
    type: "send",
    amount: 1.50,
    address: "0xXYZ987654321",
    date: "23 Mar 2026",
    time: "04:10 PM",
    status: "Completed",
    coinName: "ETH",
  ),
];

bool notificationsEnabled = true;
bool darkModeEnabled = true;
bool hideBalance = false;
