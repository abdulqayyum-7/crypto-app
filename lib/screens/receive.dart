import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

  final String walletAddress =
      "0xA1B2C3D4E5F6G7H8I9J0";

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

          "Receive",

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

                      color:
                      Colors.white,

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

                      size: 230,
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
                          Icons.account_balance_wallet,
                          color:
                          Color(0xFF4FC3F7),
                        ),

                        SizedBox(width: 10),

                        Text(

                          "Crypto Wallet Address",

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

                  Row(

                    children: [

                      Expanded(

                        child: ElevatedButton.icon(

                          onPressed: () async {

                            await Clipboard.setData(
                              ClipboardData(
                                text: walletAddress,
                              ),
                            );

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              const SnackBar(
                                content:
                                Text(
                                  "Address copied",
                                ),
                              ),
                            );
                          },

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            const Color(
                              0xFF4FC3F7,
                            ),

                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),

                          icon: const Icon(
                            Icons.copy,
                            color: Colors.white,
                          ),

                          label: const Text(

                            "Copy",

                            style: TextStyle(

                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(

                        child: ElevatedButton.icon(

                          onPressed: () {

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              const SnackBar(
                                content:
                                Text(
                                  "Share feature coming soon",
                                ),
                              ),
                            );
                          },

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            const Color(
                              0xFF7C4DFF,
                            ),

                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),

                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),

                          label: const Text(

                            "Share",

                            style: TextStyle(

                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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