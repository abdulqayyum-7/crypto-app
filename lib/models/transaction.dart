class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String address;
  final String date;
  final String time;
  final String status;
  final String coinName;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.coinName,
  });

  factory TransactionModel.fromFirestore(
      Map<String, dynamic> data,
      String documentId,
      ) {
    return TransactionModel(
      id: documentId,
      type: data['type'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      address: data['address'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      status: data['status'] ?? '',
      coinName: data['coinName'] ?? '',
    );
  }
}