import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_details.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState
    extends State<TransactionScreen> {

  String searchText = "";

  String selectedFilter = "All";

  List<TransactionModel> filterTransactions(
      List<TransactionModel> transactions,
      ) {

    return transactions.where((tx) {

      final matchesSearch =

          tx.coinName
              .toLowerCase()
              .contains(
            searchText.toLowerCase(),
          ) ||

              tx.address
                  .toLowerCase()
                  .contains(
                searchText.toLowerCase(),
              ) ||

              tx.type
                  .toLowerCase()
                  .contains(
                searchText.toLowerCase(),
              );

      final matchesFilter =

      selectedFilter == "All"
          ? true
          : tx.type.toLowerCase() ==
          selectedFilter.toLowerCase();

      return matchesSearch &&
          matchesFilter;

    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Transactions",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            /// SEARCH
            TextField(

              decoration: InputDecoration(

                hintText:
                "Search transaction",

                prefixIcon:
                const Icon(
                  Icons.search,
                  color:
                  Color(0xFF4FC3F7),
                ),

                filled: true,

                fillColor: Colors.white,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),

                  borderSide:
                  BorderSide.none,
                ),

                enabledBorder:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),

                  borderSide:
                  const BorderSide(
                    color:
                    Colors.black12,
                  ),
                ),

                focusedBorder:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),

                  borderSide:
                  const BorderSide(
                    color:
                    Color(0xFF4FC3F7),
                    width: 1.5,
                  ),
                ),
              ),

              onChanged: (value) {

                setState(() {
                  searchText = value;
                });
              },
            ),

            const SizedBox(height: 16),

            /// FILTER
            DropdownButtonFormField<String>(

              value: selectedFilter,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),

                  borderSide:
                  BorderSide.none,
                ),

                enabledBorder:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),

                  borderSide:
                  const BorderSide(
                    color:
                    Colors.black12,
                  ),
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: "All",
                  child: Text("All"),
                ),

                DropdownMenuItem(
                  value: "send",
                  child: Text("Send"),
                ),

                DropdownMenuItem(
                  value: "receive",
                  child: Text("Receive"),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  selectedFilter =
                  value!;
                });
              },
            ),

            const SizedBox(height: 18),

            Expanded(

              child:
              StreamBuilder<QuerySnapshot>(

                stream:
                FirebaseFirestore.instance
                    .collection(
                  'transactions',
                )
                    .where(
                  'uid',
                  isEqualTo:
                  user!.uid,
                )
                    .orderBy(
                  'timestamp',
                  descending: true,
                )
                    .snapshots(),

                builder:
                    (context, snapshot) {

                  if (snapshot
                      .connectionState ==
                      ConnectionState
                          .waiting) {

                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!
                          .docs
                          .isEmpty) {

                    return Center(

                      child: Column(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        children: [

                          Icon(
                            Icons.receipt_long,
                            size: 70,
                            color:
                            Colors.grey.shade400,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          const Text(

                            "No transactions found",

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final transactions =
                  snapshot.data!.docs
                      .map((doc) {

                    return TransactionModel
                        .fromFirestore(

                      doc.data()
                      as Map<String,
                          dynamic>,

                      doc.id,
                    );

                  }).toList();

                  final filteredTransactions =
                  filterTransactions(
                    transactions,
                  );

                  if (filteredTransactions
                      .isEmpty) {

                    return const Center(
                      child: Text(
                        "No matching transaction",
                      ),
                    );
                  }

                  return ListView.builder(

                    itemCount:
                    filteredTransactions
                        .length,

                    itemBuilder:
                        (context, index) {

                      final tx =
                      filteredTransactions[
                      index];

                      final isSend =
                          tx.type ==
                              "send";

                      return Container(

                        margin:
                        const EdgeInsets.only(
                          bottom: 14,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                            20,
                          ),

                          border: Border.all(
                            color:
                            Colors.black12,
                          ),
                        ),

                        child: ListTile(

                          contentPadding:
                          const EdgeInsets.all(
                            14,
                          ),

                          leading:
                          CircleAvatar(

                            radius: 26,

                            backgroundColor:

                            isSend
                                ? Colors.red
                                .withOpacity(
                              0.12,
                            )
                                : Colors.green
                                .withOpacity(
                              0.12,
                            ),

                            child: Icon(

                              isSend
                                  ? Icons
                                  .arrow_upward
                                  : Icons
                                  .arrow_downward,

                              color:
                              isSend
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),

                          title: Text(

                            "${tx.coinName} ${tx.type.toUpperCase()}",

                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),

                          subtitle: Padding(

                            padding:
                            const EdgeInsets.only(
                              top: 6,
                            ),

                            child: Text(
                              tx.address,
                            ),
                          ),

                          trailing:
                          Column(

                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .end,

                            children: [

                              Text(

                                "${tx.amount}",

                                style:
                                TextStyle(

                                  fontWeight:
                                  FontWeight.bold,

                                  fontSize: 17,

                                  color:
                                  isSend
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                tx.coinName,
                              ),
                            ],
                          ),

                          onTap: () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    TransactionDetailsScreen(
                                      tx: tx,
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}