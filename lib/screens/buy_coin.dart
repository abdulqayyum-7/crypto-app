import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/coin.dart';

class BuyCoinScreen extends StatefulWidget {
  final List<Coin> coins;

  const BuyCoinScreen({
    super.key,
    required this.coins,
  });

  @override
  State<BuyCoinScreen> createState() =>
      _BuyCoinScreenState();
}

class _BuyCoinScreenState
    extends State<BuyCoinScreen> {

  Coin? selectedCoin;

  final TextEditingController amountController =
  TextEditingController();

  String selectedPaymentMethod =
      "JazzCash";

  bool isLoading = false;

  final List<String> paymentMethods = [

    "JazzCash",
    "EasyPaisa",
    "Bank Account",
    "Credit Card",
  ];

  double get calculatedUnits {

    if (selectedCoin == null) {
      return 0;
    }

    double amount =
        double.tryParse(
          amountController.text,
        ) ??
            0;

    if (amount <= 0) {
      return 0;
    }

    return amount / selectedCoin!.price;
  }

  Future<void> buyCoin() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (selectedCoin == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a coin",
          ),
        ),
      );

      return;
    }

    double amount =
        double.tryParse(
          amountController.text,
        ) ??
            0;

    if (amount <= 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Enter valid amount",
          ),
        ),
      );

      return;
    }

    double units = calculatedUnits;

    setState(() {
      isLoading = true;
    });

    try {

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("portfolio")
          .add({

        "coin":
        selectedCoin!.symbol,

        "amount":
        units,

        "price":
        selectedCoin!.price,

        "investedAmount":
        amount,

        "paymentMethod":
        selectedPaymentMethod,

        "type":
        "buy",

        "timestamp":
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "${selectedCoin!.name} purchased successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(
          label,

          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 8),

        TextField(

          controller: controller,

          keyboardType:
          TextInputType.number,

          onChanged: (value) {
            setState(() {});
          },

          decoration: InputDecoration(

            hintText: hint,

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16),
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
                color: Color(0xFF4FC3F7),
                width: 2,
              ),
            ),

            filled: true,

            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget paymentMethodCard({
    required String title,
    required bool isSelected,
  }) {

    return Container(

      margin:
      const EdgeInsets.only(bottom: 12),

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(

          color:
          isSelected
              ? const Color(0xFF4FC3F7)
              : Colors.black12,

          width:
          isSelected ? 2 : 1,
        ),
      ),

      child: Row(
        children: [

          CircleAvatar(

            backgroundColor:
            const Color(0xFF4FC3F7)
                .withOpacity(0.12),

            child: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFF4FC3F7),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(

              title,

              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),

          Radio<String>(

            value: title,

            groupValue:
            selectedPaymentMethod,

            activeColor:
            const Color(0xFF4FC3F7),

            onChanged: (value) {

              setState(() {

                selectedPaymentMethod =
                value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget summaryRow(
      String title,
      String value,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(bottom: 12),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(

            title,

            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),

          Text(

            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Buy Coin",

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

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

            child: const Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  "Crypto Purchase",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(

                  "Buy cryptocurrency using secure payment methods.",

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(

            "Select Coin",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<Coin>(

            value: selectedCoin,

            decoration: InputDecoration(

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),
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
                  color: Color(0xFF4FC3F7),
                  width: 2,
                ),
              ),

              filled: true,

              fillColor: Colors.white,
            ),

            items:
            widget.coins.map((coin) {

              return DropdownMenuItem(

                value: coin,

                child: Text(
                  "${coin.name} (${coin.symbol})",
                ),
              );
            }).toList(),

            onChanged: (value) {

              setState(() {

                selectedCoin = value;
              });
            },
          ),

          const SizedBox(height: 22),

          buildTextField(

            label: "Amount (USD)",

            controller:
            amountController,

            hint:
            "Enter investment amount",
          ),

          const SizedBox(height: 20),

          Container(

            padding:
            const EdgeInsets.all(18),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(20),

              border: Border.all(
                color: Colors.black12,
              ),
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  "Purchase Summary",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                summaryRow(
                  "Coin",
                  selectedCoin?.symbol ?? "-",
                ),

                summaryRow(
                  "Investment",
                  "\$${amountController.text.isEmpty ? "0" : amountController.text}",
                ),

                summaryRow(
                  "Units",
                  calculatedUnits
                      .toStringAsFixed(6),
                ),

                summaryRow(
                  "Current Price",
                  selectedCoin == null
                      ? "-"
                      : "\$${selectedCoin!.price.toStringAsFixed(2)}",
                ),

                summaryRow(
                  "Payment",
                  selectedPaymentMethod,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(

            "Choose Payment Method",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          ...paymentMethods.map(

                (method) =>
                paymentMethodCard(
                  title: method,
                  isSelected:
                  selectedPaymentMethod ==
                      method,
                ),
          ),

          const SizedBox(height: 30),

          SizedBox(

            height: 56,

            child: ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                const Color(0xFF4FC3F7),

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      18),
                ),
              ),

              onPressed:
              isLoading
                  ? null
                  : buyCoin,

              child:
              isLoading

                  ? const SizedBox(

                width: 24,
                height: 24,

                child:
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )

                  : const Text(

                "Confirm Purchase",

                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}