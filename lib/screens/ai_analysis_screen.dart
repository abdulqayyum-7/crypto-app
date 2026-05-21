import 'package:flutter/material.dart';

import '../models/coin.dart';
import '../services/gemini_service.dart';

class AIAnalysisScreen extends StatefulWidget {

  final List<Coin> coins;

  const AIAnalysisScreen({
    super.key,
    required this.coins,
  });

  @override
  State<AIAnalysisScreen> createState() =>
      _AIAnalysisScreenState();
}

class _AIAnalysisScreenState
    extends State<AIAnalysisScreen> {

  bool isLoading = true;

  String aiResult = "";

  @override
  void initState() {
    super.initState();
    analyzePortfolio();
  }

  Future<void> analyzePortfolio() async {

    try {

      String portfolioData = "";

      for (var coin in widget.coins) {

        portfolioData +=
        "${coin.name} (${coin.symbol}) "
            "- Amount: ${coin.amount.toStringAsFixed(4)}, "
            "Current Price: \$${coin.price.toStringAsFixed(2)}\n";
      }

      final result =
      await GeminiService()
          .analyzePortfolio(
        portfolioData: portfolioData,
      );

      setState(() {

        aiResult = result;

        isLoading = false;
      });

    } catch (e) {

      setState(() {

        aiResult =
        "Unable to analyze portfolio.";

        isLoading = false;
      });
    }
  }

  Widget buildAnalysisCard(String text) {

    List<String> lines =
    text
        .replaceAll("*", "")
        .split("\n")
        .where(
          (e) => e.trim().isNotEmpty,
    )
        .toList();

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: Colors.black12,
        ),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(0.04),

            blurRadius: 10,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Container(

                padding:
                const EdgeInsets.all(10),

                decoration: BoxDecoration(

                  color:
                  const Color(0xFF4FC3F7)
                      .withOpacity(0.12),

                  borderRadius:
                  BorderRadius.circular(12),
                ),

                child: const Icon(

                  Icons.analytics,

                  color:
                  Color(0xFF4FC3F7),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(

                child: Text(

                  "AI Portfolio Analysis",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ...lines.map(

                (line) {

              return Container(

                margin:
                const EdgeInsets.only(
                  bottom: 14,
                ),

                padding:
                const EdgeInsets.all(14),

                decoration: BoxDecoration(

                  color:
                  Colors.grey.shade50,

                  borderRadius:
                  BorderRadius.circular(14),

                  border: Border.all(
                    color:
                    Colors.black12,
                  ),
                ),

                child: Row(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Padding(

                      padding:
                      EdgeInsets.only(
                        top: 5,
                      ),

                      child: Icon(

                        Icons.circle,

                        size: 10,

                        color:
                        Color(0xFF4FC3F7),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(

                      child: Text(

                        line,

                        style:
                        const TextStyle(

                          fontSize: 14,

                          height: 1.5,

                          color:
                          Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget portfolioCard(Coin coin) {

    double totalValue =
        coin.amount * coin.price;

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

            radius: 24,

            backgroundColor:
            const Color(
                0xFF4FC3F7)
                .withOpacity(0.12),

            child: Text(

              coin.symbol[0],

              style: const TextStyle(
                color:
                Color(0xFF4FC3F7),

                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  coin.name,

                  style:
                  const TextStyle(

                    fontSize: 16,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(

                  "${coin.amount.toStringAsFixed(4)} ${coin.symbol}",

                  style: TextStyle(
                    color:
                    Colors.grey.shade700,
                  ),
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

                style:
                const TextStyle(

                  fontWeight:
                  FontWeight.bold,

                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 4),

              Text(

                "\$${totalValue.toStringAsFixed(2)}",

                style: TextStyle(
                  color:
                  Colors.green.shade700,

                  fontSize: 12,
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

          "Portfolio Analysis",

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

          : ListView(

        padding:
        const EdgeInsets.all(16),

        children: [

          buildAnalysisCard(aiResult),

          const SizedBox(height: 22),

          const Text(

            "Portfolio Assets",

            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ...widget.coins.map(
                (coin) =>
                portfolioCard(coin),
          ),
        ],
      ),
    );
  }
}