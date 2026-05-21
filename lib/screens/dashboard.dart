import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/coin.dart';
import '../services/coin_api_service.dart';
import 'ai_analysis_screen.dart';
import 'buy_coin.dart';
import 'prediction_screen.dart';
import 'receive.dart';
import 'send.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  final CoinApiService apiService =
  CoinApiService();

  bool isLoading = true;

  List<Coin> coins = [];

  double totalPortfolio = 0;

  double totalInvestment = 0;

  double totalProfitLoss = 0;

  List<FlSpot> portfolioSpots = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final prices =
    await apiService.fetchCoins();

    final snapshot =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("portfolio")
        .orderBy("timestamp")
        .get();

    Map<String, double> amounts = {

      "BTC": 0,
      "ETH": 0,
      "SOL": 0,
      "BNB": 0,
    };

    double totalBuyValue = 0;

    double totalSellValue = 0;

    List<FlSpot> spots = [];

    int index = 0;

    for (var doc in snapshot.docs) {

      final data = doc.data();

      String coin =
          data["coin"] ?? "BTC";

      double amount =
      (data["amount"] as num)
          .toDouble();

      double transactionPrice =
      (data["price"] as num)
          .toDouble();

      String type =
          data["type"] ?? "buy";

      if (type == "buy" ||
          type == "receive") {

        amounts[coin] =
            (amounts[coin] ?? 0) +
                amount;

        totalBuyValue +=
            amount * transactionPrice;

      } else if (type == "sell" ||
          type == "send") {

        amounts[coin] =
            (amounts[coin] ?? 0) -
                amount;

        totalSellValue +=
            amount * transactionPrice;

        if (amounts[coin]! < 0) {
          amounts[coin] = 0;
        }
      }

      double runningPortfolio = 0;

      amounts.forEach((symbol, qty) {

        double currentPrice =
            prices[symbol] ?? 0;

        runningPortfolio +=
            qty * currentPrice;
      });

      spots.add(
        FlSpot(
          index.toDouble(),
          runningPortfolio,
        ),
      );

      index++;
    }

    if (spots.isEmpty) {

      spots = [

        const FlSpot(0, 0),
        const FlSpot(1, 0),
      ];
    }

    List<Coin> loaded = [

      Coin(
        name: "Bitcoin",
        symbol: "BTC",
        amount: amounts["BTC"]!,
        price: prices["BTC"] ?? 0,
      ),

      Coin(
        name: "Ethereum",
        symbol: "ETH",
        amount: amounts["ETH"]!,
        price: prices["ETH"] ?? 0,
      ),

      Coin(
        name: "Solana",
        symbol: "SOL",
        amount: amounts["SOL"]!,
        price: prices["SOL"] ?? 0,
      ),

      Coin(
        name: "Binance",
        symbol: "BNB",
        amount: amounts["BNB"]!,
        price: prices["BNB"] ?? 0,
      ),
    ];

    double currentPortfolio = 0;

    for (var coin in loaded) {

      currentPortfolio +=
          coin.amount * coin.price;
    }

    double investedAmount =
        totalBuyValue -
            totalSellValue;

    double profitLoss =
        currentPortfolio -
            investedAmount;

    setState(() {

      coins = loaded;

      totalPortfolio =
          currentPortfolio;

      totalInvestment =
          investedAmount;

      totalProfitLoss =
          profitLoss;

      portfolioSpots = spots;

      isLoading = false;
    });
  }

  Widget actionButton({

    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {

    return Expanded(

      child: InkWell(

        onTap: onTap,

        borderRadius:
        BorderRadius.circular(16),

        child: Container(

          padding:
          const EdgeInsets.symmetric(
            vertical: 15,
          ),

          decoration: BoxDecoration(

            color:
            const Color(0xFF4FC3F7),

            borderRadius:
            BorderRadius.circular(16),
          ),

          child: Row(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),

              const SizedBox(width: 8),

              Flexible(

                child: Text(

                  text,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(

                    color: Colors.white,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget analyticsCard({

    required String title,
    required String value,
    required IconData icon,
  }) {

    return Expanded(

      child: Container(

        padding:
        const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(18),

          border: Border.all(
            color: Colors.black12,
          ),
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            CircleAvatar(

              backgroundColor:
              const Color(0xFF4FC3F7)
                  .withOpacity(0.1),

              child: Icon(
                icon,
                color:
                const Color(0xFF4FC3F7),
              ),
            ),

            const SizedBox(height: 12),

            Text(

              title,

              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 6),

            Text(

              value,

              style: const TextStyle(
                fontWeight:
                FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget graphWidget() {

    double maxY = 100;

    if (portfolioSpots.isNotEmpty) {

      maxY = portfolioSpots
          .map((e) => e.y)
          .reduce(
            (a, b) => a > b ? a : b,
      );

      if (maxY < 100) {
        maxY = 100;
      }
    }

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(22),

        border: Border.all(
          color: Colors.black12,
        ),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              const Text(

                "Portfolio Performance",

                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              TextButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          PredictionScreen(
                            coins: coins,
                          ),
                    ),
                  );
                },

                child: const Text(

                  "Prediction",

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(

            height: 300,

            child: Padding(

              padding:
              const EdgeInsets.only(
                left: 8,
                right: 18,
                bottom: 8,
                top: 10,
              ),

              child: LineChart(

                LineChartData(

                  minX: 0,

                  maxX:
                  portfolioSpots.length > 1
                      ? portfolioSpots.length
                      .toDouble() - 1
                      : 1,

                  minY: 0,

                  maxY:
                  maxY + (maxY * 0.15),

                  gridData: FlGridData(

                    show: true,

                    horizontalInterval:
                    maxY / 6,

                    verticalInterval: 1,
                  ),

                  borderData: FlBorderData(

                    show: true,

                    border: Border.all(
                      color: Colors.black26,
                    ),
                  ),

                  titlesData: FlTitlesData(

                    topTitles: AxisTitles(

                      sideTitles:
                      SideTitles(
                        showTitles: false,
                      ),
                    ),

                    rightTitles:
                    AxisTitles(

                      sideTitles:
                      SideTitles(
                        showTitles: false,
                      ),
                    ),

                    leftTitles:
                    AxisTitles(

                      sideTitles:
                      SideTitles(

                        showTitles: true,

                        reservedSize: 55,

                        interval:
                        maxY / 6,

                        getTitlesWidget:
                            (
                            value,
                            meta,
                            ) {

                          return Padding(

                            padding:
                            const EdgeInsets.only(
                              right: 6,
                            ),

                            child: Text(

                              "\$${value.toInt()}",

                              textAlign:
                              TextAlign.right,

                              style:
                              const TextStyle(
                                fontSize: 10,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    bottomTitles:
                    AxisTitles(

                      sideTitles:
                      SideTitles(

                        showTitles: true,

                        reservedSize: 30,

                        interval:
                        portfolioSpots.length > 10
                            ? 2
                            : 1,

                        getTitlesWidget:
                            (
                            value,
                            meta,
                            ) {

                          return Padding(

                            padding:
                            const EdgeInsets.only(
                              top: 6,
                            ),

                            child: Text(

                              "${value.toInt() + 1}",

                              style:
                              const TextStyle(
                                fontSize: 10,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  lineBarsData: [

                    LineChartBarData(

                      spots:
                      portfolioSpots,

                      isCurved: false,

                      barWidth: 4,

                      dotData:
                      FlDotData(
                        show: true,
                      ),

                      belowBarData:
                      BarAreaData(

                        show: true,

                        color:
                        const Color(
                            0xFF4FC3F7)
                            .withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget coinCard(Coin coin) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: Colors.black12,
        ),
      ),

      child: Row(

        children: [

          CircleAvatar(

            backgroundColor:
            const Color(
                0xFF4FC3F7)
                .withOpacity(0.1),

            child: Text(
              coin.symbol[0],
            ),
          ),

          const SizedBox(width: 14),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(

                  coin.name,

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Text(
                  "${coin.amount.toStringAsFixed(4)} ${coin.symbol}",
                ),
              ],
            ),
          ),

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [

              Text(

                "\$${coin.price.toStringAsFixed(2)}",

                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(

                "Current Price",

                style: TextStyle(
                  color:
                  Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.grey.shade100,

      appBar: AppBar(

        backgroundColor:
        Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Dashboard",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body:
      isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          padding:
          const EdgeInsets.all(16),

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
                BorderRadius.circular(
                    22),
              ),

              child: Column(

                children: [

                  const Text(

                    "Portfolio Balance",

                    style: TextStyle(
                      color:
                      Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    "\$${totalPortfolio.toStringAsFixed(2)}",

                    textAlign:
                    TextAlign.center,

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                      fontSize: 32,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                actionButton(

                  text: "Send",

                  icon: Icons.send,

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SendScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 10),

                actionButton(

                  text: "Receive",

                  icon:
                  Icons.download,

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ReceiveScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                actionButton(

                  text: "Buy Coin",

                  icon:
                  Icons.currency_bitcoin,

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            BuyCoinScreen(
                              coins: coins,
                            ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 10),

                actionButton(

                  text:
                  "Portfolio Analysis",

                  icon:
                  Icons.analytics,

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            AIAnalysisScreen(
                              coins: coins,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                analyticsCard(

                  title:
                  "Investment",

                  value:
                  "\$${totalInvestment.toStringAsFixed(2)}",

                  icon:
                  Icons.account_balance_wallet,
                ),

                const SizedBox(width: 12),

                analyticsCard(

                  title:
                  totalProfitLoss >= 0
                      ? "Profit"
                      : "Loss",

                  value:
                  "\$${totalProfitLoss.toStringAsFixed(2)}",

                  icon:
                  totalProfitLoss >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                ),
              ],
            ),

            const SizedBox(height: 20),

            graphWidget(),

            const SizedBox(height: 20),

            const Text(

              "Portfolio Coins",

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            ...coins.map(
                  (e) => coinCard(e),
            ),
          ],
        ),
      ),
    );
  }
}