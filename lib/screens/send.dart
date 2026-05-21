import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() =>
      _SendScreenState();
}

class _SendScreenState
    extends State<SendScreen> {

  final TextEditingController
  amountController =
  TextEditingController();

  final TextEditingController
  addressController =
  TextEditingController();

  String selectedCoin = "BTC";

  bool loading = false;

  Future<void> sendCoin() async {

    String amountText =
    amountController.text.trim();

    String address =
    addressController.text.trim();

    if (amountText.isEmpty ||
        address.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Fill all fields"),
        ),
      );

      return;
    }

    double amount =
        double.tryParse(amountText) ?? 0;

    if (amount <= 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Invalid amount"),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) return;

      // =========================
      // GET PORTFOLIO DATA
      // =========================

      final portfolioSnapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("portfolio")
          .get();

      double currentBalance = 0;

      for (var doc in portfolioSnapshot.docs) {

        final data = doc.data();

        String coin =
            data["coin"] ?? "";

        double units =
            (data["amount"] as num?)
                ?.toDouble() ?? 0;

        String type =
            data["type"] ?? "";

        if (coin == selectedCoin) {

          if (type == "buy" ||
              type == "receive") {

            currentBalance += units;

          } else if (type == "send" ||
              type == "sell") {

            currentBalance -= units;
          }
        }
      }

      // =========================
      // CHECK BALANCE
      // =========================

      if (amount > currentBalance) {

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "Insufficient balance\nAvailable: ${currentBalance.toStringAsFixed(4)} $selectedCoin",
            ),
          ),
        );

        return;
      }

      // =========================
      // GET CURRENT PRICE
      // =========================

      double currentPrice = 0;

      for (var doc in portfolioSnapshot.docs) {

        final data = doc.data();

        if (data["coin"] ==
            selectedCoin) {

          currentPrice =
              (data["price"] as num?)
                  ?.toDouble() ?? 0;
        }
      }

      // =========================
      // SAVE SEND TRANSACTION
      // =========================

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("portfolio")
          .add({

        "coin": selectedCoin,

        "amount": amount,

        "price": currentPrice,

        "type": "send",

        "address": address,

        "timestamp":
        FieldValue.serverTimestamp(),
      });

      // =========================
      // SAVE TRANSACTION HISTORY
      // =========================

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("transactions")
          .add({

        "coin": selectedCoin,

        "amount": amount,

        "address": address,

        "type": "send",

        "timestamp":
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "$amount $selectedCoin Sent Successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(e.toString()),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  InputDecoration fieldDecoration(
      String hint,
      IconData icon,
      ) {

    return InputDecoration(

      hintText: hint,

      prefixIcon: Icon(
        icon,
        color:
        const Color(0xFF4FC3F7),
      ),

      filled: true,

      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),

        borderSide: BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),

        borderSide:
        const BorderSide(
          color: Colors.black12,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),

        borderSide:
        const BorderSide(
          color:
          Color(0xFF4FC3F7),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Send Coin",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(18),

        child: Column(
          children: [

            Container(

              padding:
              const EdgeInsets.all(22),

              decoration: BoxDecoration(

                gradient:
                const LinearGradient(
                  colors: [
                    Color(0xFF4FC3F7),
                    Color(0xFF7C4DFF),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(24),
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 52,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Send Cryptocurrency",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Transfer crypto securely",

                    style: TextStyle(
                      color:
                      Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            DropdownButtonFormField(
              value: selectedCoin,

              decoration:
              fieldDecoration(
                "Select Coin",
                Icons.currency_bitcoin,
              ),

              items: const [

                DropdownMenuItem(
                  value: "BTC",
                  child: Text(
                    "Bitcoin (BTC)",
                  ),
                ),

                DropdownMenuItem(
                  value: "ETH",
                  child: Text(
                    "Ethereum (ETH)",
                  ),
                ),

                DropdownMenuItem(
                  value: "SOL",
                  child: Text(
                    "Solana (SOL)",
                  ),
                ),

                DropdownMenuItem(
                  value: "BNB",
                  child: Text(
                    "Binance (BNB)",
                  ),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  selectedCoin =
                  value!;
                });
              },
            ),

            const SizedBox(height: 18),

            TextField(
              controller:
              amountController,

              keyboardType:
              TextInputType.number,

              decoration:
              fieldDecoration(
                "Coin Units",
                Icons.account_balance_wallet,
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller:
              addressController,

              decoration:
              fieldDecoration(
                "Wallet Address",
                Icons.wallet,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 56,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(
                    0xFF4FC3F7,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                  ),
                ),

                onPressed:
                loading
                    ? null
                    : sendCoin,

                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(

                  "Send",

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,

                    fontSize: 17,
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