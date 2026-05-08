import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  State<ReceiveScreen> createState() =>
      _ReceiveScreenState();
}

class _ReceiveScreenState
    extends State<ReceiveScreen> {

  final TextEditingController amountController =
  TextEditingController();

  final String walletAddress =
      "btc_7HGS82JSK92KSLA91J";

  bool loading = false;

  Future<void> receiveCoin() async {

    String amount =
    amountController.text.trim();

    if (amount.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Enter amount"),
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

      await FirebaseFirestore.instance
          .collection("transactions")
          .add({

        "userId": user!.uid,

        "type": "receive",

        "coinName": "BTC",

        "amount": amount,

        "address": walletAddress,

        "timestamp":
        FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("BTC received successfully"),
        ),
      );

      amountController.clear();

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.white,

      appBar: AppBar(

        backgroundColor:
        Colors.white,

        elevation: 0,

        centerTitle: true,

        leading: IconButton(

          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(

          "Receive BTC",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(24),

              decoration: BoxDecoration(

                color:
                Colors.white,

                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black.withOpacity(
                      0.05,
                    ),

                    blurRadius: 14,
                    offset:
                    const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(

                children: [

                  const Text(

                    "Scan QR Code",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(

                    padding:
                    const EdgeInsets.all(18),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        22,
                      ),

                      border: Border.all(
                        color:
                        Colors.grey.shade300,
                      ),
                    ),

                    child: QrImageView(

                      data: walletAddress,

                      version:
                      QrVersions.auto,

                      size: 220,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(

                    width: double.infinity,

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 18,
                    ),

                    decoration: BoxDecoration(

                      color:
                      const Color(
                        0xFFF5F7FB,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: Row(

                      children: const [

                        Icon(
                          Icons.currency_bitcoin,
                          color:
                          Color(0xFF4FC3F7),
                        ),

                        SizedBox(width: 10),

                        Text(

                          "Bitcoin Wallet (BTC)",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(

                    alignment:
                    Alignment.centerLeft,

                    child: Text(

                      "Wallet Address",

                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(

                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(16),

                    decoration: BoxDecoration(

                      color:
                      const Color(
                        0xFFF5F7FB,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: SelectableText(

                      walletAddress,

                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(

                    controller:
                    amountController,

                    keyboardType:
                    TextInputType.number,

                    decoration: InputDecoration(

                      hintText:
                      "Enter BTC amount",

                      filled: true,

                      fillColor:
                      const Color(
                        0xFFF5F7FB,
                      ),

                      prefixIcon:
                      const Icon(
                        Icons.account_balance_wallet,
                      ),

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(

                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(

                      onPressed:
                      loading
                          ? null
                          : receiveCoin,

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

                      child:
                      loading
                          ? const SizedBox(

                        height: 24,
                        width: 24,

                        child:
                        CircularProgressIndicator(
                          color:
                          Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : const Text(

                        "Receive BTC",

                        style: TextStyle(

                          color:
                          Colors.white,

                          fontSize: 16,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}