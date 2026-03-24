class TransactionModel {
  String type;
  double amount;
  String address;
  String date;
  String time;
  String status;
  String coinName;

  TransactionModel({
    required this.type,
    required this.amount,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.coinName,
  });
}
