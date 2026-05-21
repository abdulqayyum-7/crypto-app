import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/coin.dart';
import '../services/coin_api_service.dart';

class PredictionScreen extends StatefulWidget {

  final List<Coin> coins;

  const PredictionScreen({
    super.key,
    required this.coins,
  });

  @override
  State<PredictionScreen> createState() =>
      _PredictionScreenState();
}

class _PredictionScreenState
    extends State<PredictionScreen> {

  final CoinApiService api =
  CoinApiService();

  late Coin selectedCoin;

  int selectedMonth = 6;

  final List<String> allMonths = [

    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  @override
  void initState() {
    super.initState();

    selectedCoin = widget.coins
        .where(
          (e) =>
      e.symbol != "USDT" &&
          e.symbol != "DOGE",
    )
        .first;
  }

  List<Coin> get filteredCoins {

    return widget.coins.where(
          (e) =>
      e.symbol != "USDT" &&
          e.symbol != "DOGE",
    ).toList();
  }

  List<String> generateTimelineMonths() {

    List<String> months = [];

    for (int i = -6; i <= 6; i++) {

      int index =
          (selectedMonth + i) % 12;

      if (index < 0) {
        index += 12;
      }

      months.add(
        allMonths[index],
      );
    }

    return months;
  }

  Widget predictionCard() {

    final timelineMonths =
    generateTimelineMonths();

    List<double> prediction =
    api.generatePrediction(
      selectedCoin.price,
    );

    while (prediction.length < 13) {

      prediction.add(
        prediction.last,
      );
    }

    List<FlSpot> spots = [];

    for (int i = 0;
    i < 13;
    i++) {

      spots.add(

        FlSpot(
          i.toDouble(),
          prediction[i],
        ),
      );
    }

    double maxY =
    prediction.reduce(
            (a, b) =>
        a > b ? a : b);

    double minY =
    prediction.reduce(
            (a, b) =>
        a < b ? a : b);

    double predictedPrice =
    prediction[6];

    return Container(

      padding:
      const EdgeInsets.all(18),

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
            children: [

              CircleAvatar(

                backgroundColor:
                const Color(
                    0xFF4FC3F7)
                    .withOpacity(0.12),

                child: Text(

                  selectedCoin.symbol[0],

                  style:
                  const TextStyle(
                    color:
                    Color(
                        0xFF4FC3F7),
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(

                      selectedCoin.name,

                      style:
                      const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    Text(

                      selectedCoin.symbol,

                      style:
                      const TextStyle(
                        color:
                        Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Text(

                "\$${selectedCoin.price.toStringAsFixed(2)}",

                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(

            "12 Month Market Prediction",

            style: TextStyle(
              fontWeight:
              FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(

            height: 360,

            child: Padding(

              padding:
              const EdgeInsets.only(
                left: 14,
                right: 20,
                top: 10,
                bottom: 20,
              ),

              child: LineChart(

                LineChartData(

                  minX: 0,
                  maxX: 12,

                  minY: minY * 0.95,
                  maxY: maxY * 1.05,

                  clipData:
                  FlClipData.all(),

                  gridData:
                  FlGridData(

                    show: true,

                    horizontalInterval:
                    ((maxY - minY) / 5),
                  ),

                  borderData:
                  FlBorderData(

                    show: true,

                    border: Border.all(
                      color: Colors.black26,
                    ),
                  ),

                  titlesData:
                  FlTitlesData(

                    topTitles:
                    AxisTitles(

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

                    bottomTitles:
                    AxisTitles(

                      axisNameWidget:
                      const Padding(

                        padding:
                        EdgeInsets.only(
                          top: 12,
                        ),

                        child: Text(

                          "12 Month Timeline",

                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      sideTitles:
                      SideTitles(

                        showTitles: true,

                        interval: 1,

                        reservedSize: 42,

                        getTitlesWidget:
                            (
                            value,
                            meta,
                            ) {

                          int index =
                          value.toInt();

                          if (index >= 0 &&
                              index <
                                  timelineMonths
                                      .length) {

                            bool isCenter =
                                index == 6;

                            return SideTitleWidget(

                              axisSide:
                              meta.axisSide,

                              child: Padding(

                                padding:
                                const EdgeInsets.only(
                                  top: 8,
                                ),

                                child: Text(

                                  timelineMonths[
                                  index],

                                  style:
                                  TextStyle(

                                    fontSize:
                                    isCenter
                                        ? 11
                                        : 9,

                                    fontWeight:
                                    isCenter
                                        ? FontWeight.bold
                                        : FontWeight.normal,

                                    color:
                                    isCenter
                                        ? const Color(
                                        0xFF7C4DFF)
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),

                    leftTitles:
                    AxisTitles(

                      axisNameWidget:
                      const Padding(

                        padding:
                        EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: Text(

                          "Price (USD)",

                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      sideTitles:
                      SideTitles(

                        showTitles: true,

                        reservedSize: 75,

                        interval:
                        ((maxY - minY) / 5),

                        getTitlesWidget:
                            (
                            value,
                            meta,
                            ) {

                          String label;

                          if (value >= 1000) {

                            label =
                            "\$${(value / 1000).toStringAsFixed(1)}K";

                          } else {

                            label =
                            "\$${value.toStringAsFixed(0)}";
                          }

                          return SideTitleWidget(

                            axisSide:
                            meta.axisSide,

                            child: Padding(

                              padding:
                              const EdgeInsets.only(
                                right: 6,
                              ),

                              child: Text(

                                label,

                                style:
                                const TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  lineBarsData: [

                    LineChartBarData(

                      spots: spots,

                      isCurved: true,

                      barWidth: 3,

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
                            .withOpacity(
                          0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(

            "Prediction Settings",

            style: TextStyle(
              fontWeight:
              FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<Coin>(

            value: selectedCoin,

            decoration:
            InputDecoration(

              labelText:
              "Select Coin",

              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                    14),
              ),

              filled: true,

              fillColor:
              Colors.grey.shade50,
            ),

            items:
            filteredCoins.map(
                  (coin) {

                return DropdownMenuItem(

                  value: coin,

                  child: Text(
                    coin.name,
                  ),
                );
              },
            ).toList(),

            onChanged: (value) {

              setState(() {

                selectedCoin =
                value!;
              });
            },
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<int>(

            value: selectedMonth,

            decoration:
            InputDecoration(

              labelText:
              "Select Center Month",

              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                    14),
              ),

              filled: true,

              fillColor:
              Colors.grey.shade50,
            ),

            items:
            List.generate(
              allMonths.length,
                  (index) {

                return DropdownMenuItem(

                  value: index,

                  child: Text(
                    allMonths[index],
                  ),
                );
              },
            ),

            onChanged: (value) {

              setState(() {

                selectedMonth =
                value!;
              });
            },
          ),

          const SizedBox(height: 24),

          Container(

            width: double.infinity,

            padding:
            const EdgeInsets.all(20),

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
                  20),
            ),

            child: Column(

              children: [

                const Text(

                  "Expected Price",

                  style: TextStyle(
                    color:
                    Colors.white70,
                  ),
                ),

                const SizedBox(height: 10),

                Text(

                  "\$${predictedPrice.toStringAsFixed(2)}",

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                    fontSize: 32,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(

                  "${selectedCoin.name} expected price around ${allMonths[selectedMonth]}",

                  textAlign:
                  TextAlign.center,

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                  ),
                ),
              ],
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

          "Market Prediction",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(

        child: ListView(

          padding:
          const EdgeInsets.all(16),

          children: [

            predictionCard(),
          ],
        ),
      ),
    );
  }
}