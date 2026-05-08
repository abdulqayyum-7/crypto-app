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

      final docRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(user!.uid);

      final snapshot =
      await docRef.get();

      final data =
          snapshot.data() ?? {};

      String field =
      selectedCoin.toLowerCase();

      double currentBalance =
      (data[field] ?? 0).toDouble();

      if (amount > currentBalance) {

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Insufficient balance",
            ),
          ),
        );

        return;
      }

      await docRef.update({
        field:
        currentBalance - amount,
      });

      await FirebaseFirestore.instance
          .collection('transactions')
          .add({

        'uid': user.uid,

        'type': 'send',

        'coinName': selectedCoin,

        'amount': amount,

        'address': address,

        'timestamp':
        Timestamp.now(),
      });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Coin Sent"),
        ),
      );

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
                "Amount",
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