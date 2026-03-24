import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/coin_tile.dart';
import 'send.dart';
import 'receive.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double getBalance() {
    double total = 0;
    for (var c in coins) {
      total += c.amount * c.price;
    }
    return total;
  }

  List<dynamic> sortedCoins() {
    final copiedCoins = List<dynamic>.from(coins);
    copiedCoins.sort((a, b) {
      if (a.isFavorite == b.isFavorite) return 0;
      return a.isFavorite ? -1 : 1;
    });
    return copiedCoins;
  }

  List<dynamic> recentTransactions() {
    final copied = List<dynamic>.from(transactions);
    return copied.reversed.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "My Wallet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4FC3F7),
                      Color(0xFF7C4DFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hideBalance
                                ? "••••••••"
                                : "\$${getBalance().toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              hideBalance = !hideBalance;
                            });
                          },
                          icon: Icon(
                            hideBalance
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Welcome, ${currentUser.name}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: actionButton(
                      context,
                      icon: Icons.send_rounded,
                      title: "Send",
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SendScreen(),
                          ),
                        );
                        setState(() {});
                      },
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: actionButton(
                      context,
                      icon: Icons.download_rounded,
                      title: "Receive",
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReceiveScreen(),
                          ),
                        );
                        setState(() {});
                      },
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                "Your Assets",
                style: TextStyle(
                  color: primaryText,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Tap a coin to view details",
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                flex: 3,
                child: sortedCoins().isEmpty
                    ? Center(
                  child: Text(
                    "No assets available",
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 16,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: sortedCoins().length,
                  itemBuilder: (_, i) => CoinTile(
                    coin: sortedCoins()[i],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Recent Activity",
                style: TextStyle(
                  color: primaryText,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                flex: 2,
                child: recentTransactions().isEmpty
                    ? Center(
                  child: Text(
                    "No recent transactions",
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 15,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: recentTransactions().length,
                  itemBuilder: (_, i) {
                    final tx = recentTransactions()[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(
                              0xFF4FC3F7,
                            ).withValues(alpha: 0.12),
                            child: Icon(
                              tx.type == "send"
                                  ? Icons.north_east_rounded
                                  : Icons.south_west_rounded,
                              color: const Color(0xFF4FC3F7),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${tx.type.toUpperCase()} ${tx.coinName}",
                                  style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${tx.date} • ${tx.time}",
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            tx.type == "send"
                                ? "- ${tx.amount}"
                                : "+ ${tx.amount}",
                            style: TextStyle(
                              color: tx.type == "send"
                                  ? Colors.redAccent
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionButton(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        required bool isDark,
      }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF4FC3F7), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
