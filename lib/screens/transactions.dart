import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/transaction_tile.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String searchText = "";
  String selectedFilter = "All";

  List getFilteredTransactions() {
    return transactions.where((tx) {
      final matchesSearch =
          tx.coinName.toLowerCase().contains(searchText.toLowerCase()) ||
              tx.address.toLowerCase().contains(searchText.toLowerCase()) ||
              tx.type.toLowerCase().contains(searchText.toLowerCase());

      final matchesFilter = selectedFilter == "All"
          ? true
          : tx.type.toLowerCase() == selectedFilter.toLowerCase();

      return matchesSearch && matchesFilter;
    }).toList().reversed.toList();
  }

  InputDecoration fieldDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      hintText: "Search by coin, address, or type",
      hintStyle: TextStyle(
        color: isDark ? Colors.white54 : Colors.black45,
      ),
      prefixIcon: const Icon(Icons.search, color: Color(0xFF4FC3F7)),
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
          width: 1.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = getFilteredTransactions();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.white60 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Transactions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              style: TextStyle(color: primaryText),
              decoration: fieldDecoration(context),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
              child: DropdownButton<String>(
                value: selectedFilter,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: cardColor,
                style: TextStyle(color: primaryText),
                items: const [
                  DropdownMenuItem(value: "All", child: Text("All Transactions")),
                  DropdownMenuItem(value: "send", child: Text("Send")),
                  DropdownMenuItem(value: "receive", child: Text("Receive")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: filteredTransactions.isEmpty
                  ? Center(
                child: Text(
                  "No transactions found",
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (_, i) => TransactionTile(
                  tx: filteredTransactions[i],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
