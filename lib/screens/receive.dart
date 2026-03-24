import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/transaction.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

  String getCurrentDate() {
    final now = DateTime.now();
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${now.day} ${months[now.month - 1]} ${now.year}";
  }

  String getCurrentTime() {
    final now = DateTime.now();
    int hour = now.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  void showCopiedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Wallet address copied")),
    );
  }

  void simulateReceive(BuildContext context) {
    transactions.add(
      TransactionModel(
        type: "receive",
        amount: 0.25,
        address: "My Wallet Address",
        date: getCurrentDate(),
        time: getCurrentTime(),
        status: "Completed",
        coinName: "BTC",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Demo receive transaction added")),
    );
  }

  @override
  Widget build(BuildContext context) {
    const walletAddress = "0xA1B2C3D4E5F6G7H8I9J0";
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Receive",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.download_rounded,
                    size: 42,
                    color: Color(0xFF4FC3F7),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Receive Crypto",
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Share this wallet address to receive funds",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      size: 70,
                      color: Color(0xFF4FC3F7),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    ),
                    child: const SelectableText(
                      walletAddress,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4FC3F7),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => showCopiedMessage(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4FC3F7),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text(
                        "Copy",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => simulateReceive(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4FC3F7)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4FC3F7)),
                      label: const Text(
                        "Demo Receive",
                        style: TextStyle(
                          color: Color(0xFF4FC3F7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
