import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../screens/transaction_details.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;

  const TransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.white60 : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionDetailsScreen(tx: tx),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.12),
          child: Icon(
            tx.type == "send"
                ? Icons.north_east_rounded
                : Icons.south_west_rounded,
            color: const Color(0xFF4FC3F7),
          ),
        ),
        title: Text(
          "${tx.type.toUpperCase()} ${tx.coinName}",
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${tx.date} • ${tx.time}",
          style: TextStyle(color: secondaryText),
        ),
        trailing: Text(
          tx.type == "send" ? "- ${tx.amount}" : "+ ${tx.amount}",
          style: TextStyle(
            color: tx.type == "send" ? Colors.redAccent : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
