import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/coin_api_service.dart';

class BuyCoinScreen extends StatefulWidget {
  const BuyCoinScreen({super.key});

  @override
  State<BuyCoinScreen> createState() =>
      _BuyCoinScreenState();
}

class _BuyCoinScreenState
    extends State<BuyCoinScreen> {

  final CoinApiService apiService =
  CoinApiService();

  final TextEditingController
  amountController =
  TextEditingController();

  bool isLoading = false;

  String selectedCoin = "BTC";

  String selectedPayment =
      "JazzCash";

  final List<String> coins = [
    "BTC",
    "ETH",
    "SOL",
    "BNB",
  ];

  final List<String> payments = [
    "JazzCash",
    "EasyPaisa",
    "Bank Account",
    "Demo Wallet",
  ];

  Map<String, dynamic> prices = {};

  double currentPrice = 0;

  double estimatedCoins = 0;

  double fee = 0;

  @override
  void initState() {
    super.initState();
    loadPrices();
  }

  Future<void> loadPrices() async {

    prices =
    await apiService.fetchCoins();

    updateCalculation();
  }

  void updateCalculation() {

    double enteredAmount =
        double.tryParse(
          amountController.text,
        ) ??
            0;

    currentPrice =
        prices[selectedCoin] ?? 0;

    fee = enteredAmount * 0.01;

    double finalAmount =
        enteredAmount - fee;

    if (currentPrice > 0) {

      estimatedCoins =
          finalAmount /
              currentPrice;
    }

    setState(() {});
  }

  Future<void> buyCoin() async {

    double enteredAmount =
        double.tryParse(
          amountController.text,
        ) ??
            0;

    if (enteredAmount <= 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Enter valid amount"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final user =
          FirebaseAuth.instance
              .currentUser;

      if (user == null) return;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("portfolio")
          .add({

        "coin": selectedCoin,

        "amount":
        estimatedCoins,

        "price":
        currentPrice,

        "paymentMethod":
        selectedPayment,

        "currency":
        "PKR",

        "pkrAmount":
        enteredAmount,

        "fee": fee,

        "type": "receive",

        "timestamp":
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showDialog(

        context: context,

        builder: (_) {

          return AlertDialog(

            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                  18),
            ),

            title: const Text(
              "Purchase Successful",
            ),

            content: Column(

              mainAxisSize:
              MainAxisSize.min,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "Coin: $selectedCoin",
                ),

                const SizedBox(height: 8),

                Text(
                  "Payment: $selectedPayment",
                ),

                const SizedBox(height: 8),

                Text(
                  "Amount: PKR ${enteredAmount.toStringAsFixed(0)}",
                ),

                const SizedBox(height: 8),

                Text(
                  "Fee: PKR ${fee.toStringAsFixed(0)}",
                ),

                const SizedBox(height: 8),

                Text(
                  "Received: ${estimatedCoins.toStringAsFixed(6)} $selectedCoin",
                ),
              ],
            ),

            actions: [

              ElevatedButton(

                onPressed: () {

                  Navigator.pop(
                      context);

                  Navigator.pop(
                      context);
                },

                child:
                const Text("Done"),
              ),
            ],
          );
        },
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text(e.toString()),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget infoTile({
    required String title,
    required String value,
  }) {

    return Container(

      margin:
      const EdgeInsets.only(
          bottom: 12),

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: Colors.black12,
        ),
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,

        children: [

          Text(
            title,

            style: const TextStyle(
              color: Colors.black54,
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
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
        Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Buy Coin",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: ListView(

        padding:
        const EdgeInsets.all(16),

        children: [

          Container(

            padding:
            const EdgeInsets.all(18),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(
                  22),

              border: Border.all(
                color: Colors.black12,
              ),
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                const Text(

                  "Select Coin",

                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 10),

                DropdownButtonFormField(

                  value: selectedCoin,

                  decoration:
                  InputDecoration(

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          14),
                    ),
                  ),

                  items:
                  coins.map((coin) {

                    return DropdownMenuItem(
                      value: coin,
                      child: Text(coin),
                    );
                  }).toList(),

                  onChanged: (value) {

                    setState(() {

                      selectedCoin =
                      value!;

                      updateCalculation();
                    });
                  },
                ),

                const SizedBox(
                    height: 20),

                const Text(

                  "Payment Method",

                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 10),

                DropdownButtonFormField(

                  value: selectedPayment,

                  decoration:
                  InputDecoration(

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          14),
                    ),
                  ),

                  items:
                  payments.map((e) {

                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),

                  onChanged: (value) {

                    setState(() {

                      selectedPayment =
                      value!;
                    });
                  },
                ),

                const SizedBox(
                    height: 20),

                TextField(

                  controller:
                  amountController,

                  keyboardType:
                  TextInputType.number,

                  onChanged: (value) {
                    updateCalculation();
                  },

                  decoration:
                  InputDecoration(

                    labelText:
                    "Enter Amount (PKR)",

                    hintText:
                    "Example: 50000",

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          14),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 24),

                const Text(

                  "Checkout Summary",

                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                    height: 16),

                infoTile(
                  title:
                  "Current Price",
                  value:
                  "\$${currentPrice.toStringAsFixed(2)}",
                ),

                infoTile(
                  title:
                  "Currency",
                  value: "PKR",
                ),

                infoTile(
                  title:
                  "Transaction Fee",
                  value:
                  "PKR ${fee.toStringAsFixed(0)}",
                ),

                infoTile(
                  title:
                  "Estimated Coins",
                  value:
                  "${estimatedCoins.toStringAsFixed(6)} $selectedCoin",
                ),

                const SizedBox(
                    height: 24),

                SizedBox(

                  width:
                  double.infinity,

                  height: 55,

                  child:
                  ElevatedButton(

                    style:
                    ElevatedButton
                        .styleFrom(

                      backgroundColor:
                      const Color(
                          0xFF4FC3F7),

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius
                            .circular(
                            30),
                      ),
                    ),

                    onPressed:
                    isLoading
                        ? null
                        : buyCoin,

                    child:
                    isLoading

                        ? const CircularProgressIndicator(
                      color:
                      Colors
                          .white,
                    )

                        : const Text(

                      "Proceed to Checkout",

                      style:
                      TextStyle(
                        fontSize:
                        16,
                        color:
                        Colors
                            .white,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}