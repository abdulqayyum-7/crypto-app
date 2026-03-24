import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionModel tx;

  const TransactionDetailsScreen({super.key, required this.tx});

  Widget detailRow(String title, String value, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.white60 : Colors.black54;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                color: secondaryText,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Transaction Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black12,
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.12),
                child: Icon(
                  tx.type == "send"
                      ? Icons.north_east_rounded
                      : Icons.south_west_rounded,
                  color: const Color(0xFF4FC3F7),
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tx.type.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              detailRow("Coin", tx.coinName, context),
              detailRow("Amount", tx.amount.toString(), context),
              detailRow("Wallet Address", tx.address, context),
              detailRow("Date", tx.date, context),
              detailRow("Time", tx.time, context),
              detailRow("Status", tx.status, context),
            ],
          ),
        ),
      ),
    );
  }
}
