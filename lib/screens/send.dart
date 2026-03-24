import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/transaction.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String selectedCoin = "BTC";

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

  bool isValidAddress(String address) {
    return address.length >= 8;
  }

  void confirmSend() {
    final address = addressController.text.trim();
    final amountText = amountController.text.trim();

    if (address.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (!isValidAddress(address)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid wallet address")),
      );
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Transaction"),
        content: Text(
          "Are you sure you want to send $amount $selectedCoin to:\n\n$address ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              transactions.add(
                TransactionModel(
                  type: "send",
                  amount: amount,
                  address: address,
                  date: getCurrentDate(),
                  time: getCurrentTime(),
                  status: "Completed",
                  coinName: selectedCoin,
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Crypto sent successfully")),
              );

              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  InputDecoration fieldDecoration(
      String hint,
      IconData icon,
      BuildContext context,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? Colors.white54 : Colors.black45,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF4FC3F7)),
      filled: true,
      fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF4FC3F7),
          width: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.white60 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Send Crypto",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.send_rounded,
                    color: Color(0xFF4FC3F7),
                    size: 34,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Send Funds",
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Enter wallet address, choose coin, and send securely.",
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedCoin,
              dropdownColor: cardColor,
              style: TextStyle(color: primaryText),
              decoration: fieldDecoration(
                "Select Coin",
                Icons.currency_bitcoin,
                context,
              ),
              items: coins
                  .map(
                    (coin) => DropdownMenuItem(
                  value: coin.symbol,
                  child: Text(
                    "${coin.symbol} - ${coin.name}",
                    style: TextStyle(color: primaryText),
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCoin = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: addressController,
              style: TextStyle(color: primaryText),
              decoration: fieldDecoration(
                "Recipient Wallet Address",
                Icons.account_balance_wallet_outlined,
                context,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: primaryText),
              decoration: fieldDecoration(
                "Enter Amount",
                Icons.payments_outlined,
                context,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: confirmSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FC3F7),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.send),
                label: const Text(
                  "Send Now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
