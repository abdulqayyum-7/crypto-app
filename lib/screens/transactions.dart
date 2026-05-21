import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  Color transactionColor(String type) {

    if (type == "buy" ||
        type == "receive") {

      return Colors.green;
    }

    return Colors.red;
  }

  IconData transactionIcon(String type) {

    if (type == "buy" ||
        type == "receive") {

      return Icons.arrow_downward;
    }

    return Icons.arrow_upward;
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Transaction History",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("portfolio")
            .orderBy(
          "timestamp",
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(

              child: Text(

                "No Transactions Found",

                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            );
          }

          final transactions =
              snapshot.data!.docs;

          return ListView.builder(

            padding:
            const EdgeInsets.all(16),

            itemCount:
            transactions.length,

            itemBuilder:
                (context, index) {

              final data =
              transactions[index]
                  .data()
              as Map<String, dynamic>;

              String coin =
                  data["coin"] ?? "";

              double amount =
                  (data["amount"] as num?)
                      ?.toDouble() ?? 0;

              double price =
                  (data["price"] as num?)
                      ?.toDouble() ?? 0;

              String type =
                  data["type"] ?? "";

              Timestamp? timestamp =
              data["timestamp"];

              DateTime date =
              timestamp != null
                  ? timestamp.toDate()
                  : DateTime.now();

              return Container(

                margin:
                const EdgeInsets.only(
                  bottom: 14,
                ),

                padding:
                const EdgeInsets.all(18),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                      20),

                  border: Border.all(
                    color:
                    Colors.black12,
                  ),
                ),

                child: Row(
                  children: [

                    CircleAvatar(

                      radius: 26,

                      backgroundColor:
                      transactionColor(
                        type,
                      ).withOpacity(0.12),

                      child: Icon(

                        transactionIcon(
                          type,
                        ),

                        color:
                        transactionColor(
                          type,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(

                            "$type $coin",

                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(

                            "${date.day}/${date.month}/${date.year}",

                            style:
                            TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .end,

                      children: [

                        Text(

                          "${amount.toStringAsFixed(4)} $coin",

                          style:
                          const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(

                          "\$${price.toStringAsFixed(2)}",

                          style: TextStyle(
                            color:
                            Colors.grey
                                .shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}