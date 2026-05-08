import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'receive.dart';
import 'send.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  Map<String, dynamic> prices = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPrices();
  }

  Future<void> fetchPrices() async {

    try {

      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd',
        ),
      );

      if (response.statusCode == 200) {

        setState(() {

          prices = jsonDecode(response.body);

          loading = false;
        });
      }

    } catch (e) {

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      Theme.of(context)
          .scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Crypto Wallet",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: loading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),

        builder: (context, snapshot) {

          Map<String, dynamic> userData =
          {};

          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.data() !=
                  null) {

            userData = snapshot.data!
                .data()
            as Map<String, dynamic>;
          }

          double btc =
          (userData['btc'] ?? 0)
              .toDouble();

          double eth =
          (userData['eth'] ?? 0)
              .toDouble();

          double sol =
          (userData['sol'] ?? 0)
              .toDouble();

          double btcPrice =
          prices['bitcoin']['usd']
              .toDouble();

          double ethPrice =
          prices['ethereum']['usd']
              .toDouble();

          double solPrice =
          prices['solana']['usd']
              .toDouble();

          double totalBalance =
              (btc * btcPrice) +
                  (eth * ethPrice) +
                  (sol * solPrice);

          return RefreshIndicator(

            onRefresh: fetchPrices,

            child: SingleChildScrollView(

              physics:
              const AlwaysScrollableScrollPhysics(),

              padding:
              const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// BALANCE CARD
                  Container(

                    padding:
                    const EdgeInsets.all(
                      24,
                    ),

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(
                        colors: [
                          Color(
                            0xFF4FC3F7,
                          ),
                          Color(
                            0xFF7C4DFF,
                          ),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        const Text(
                          "Total Balance",

                          style: TextStyle(
                            color:
                            Colors.white70,

                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          "\$${totalBalance.toStringAsFixed(2)}",

                          style:
                          const TextStyle(
                            color:
                            Colors.white,

                            fontSize: 32,

                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        Row(
                          children: [

                            Expanded(
                              child:
                              ElevatedButton.icon(

                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors
                                      .white,

                                  foregroundColor:
                                  Colors
                                      .black,
                                ),

                                onPressed: () {

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                      const SendScreen(),
                                    ),
                                  );
                                },

                                icon:
                                const Icon(
                                  Icons.send,
                                ),

                                label:
                                const Text(
                                  "Send",
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(
                              child:
                              ElevatedButton.icon(

                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors
                                      .white,

                                  foregroundColor:
                                  Colors
                                      .black,
                                ),

                                onPressed: () {

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                      const ReceiveScreen(),
                                    ),
                                  );
                                },

                                icon:
                                const Icon(
                                  Icons.download,
                                ),

                                label:
                                const Text(
                                  "Receive",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Your Coins",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  buildCoinCard(
                    context,
                    "Bitcoin",
                    "BTC",
                    btc,
                    btcPrice,
                    Icons.currency_bitcoin,
                  ),

                  buildCoinCard(
                    context,
                    "Ethereum",
                    "ETH",
                    eth,
                    ethPrice,
                    Icons.token,
                  ),

                  buildCoinCard(
                    context,
                    "Solana",
                    "SOL",
                    sol,
                    solPrice,
                    Icons.bolt,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCoinCard(
      BuildContext context,
      String name,
      String symbol,
      double amount,
      double price,
      IconData icon,
      ) {

    return Container(

      margin:
      const EdgeInsets.only(bottom: 14),

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color:
        Theme.of(context).cardColor,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: Colors.black12,
        ),
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 24,

            backgroundColor:
            const Color(0xFF4FC3F7)
                .withOpacity(0.12),

            child: Icon(
              icon,
              color:
              const Color(0xFF4FC3F7),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  name,

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,

                    fontSize: 18,
                  ),
                ),

                Text(symbol),
              ],
            ),
          ),

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [

              Text(
                amount.toString(),

                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,

                  fontSize: 18,
                ),
              ),

              Text(
                "\$${price.toStringAsFixed(2)}",
              ),
            ],
          ),
        ],
      ),
    );
  }
}