import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'transactions.dart';
import 'settings.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() =>
      _MainNavScreenState();
}

class _MainNavScreenState
    extends State<MainNavScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = const [

    DashboardScreen(),

    TransactionScreen(),

    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      body: screens[selectedIndex],

      bottomNavigationBar: Container(

        decoration: BoxDecoration(

          color: Colors.white,

          boxShadow: [

            BoxShadow(
              color:
              Colors.black.withOpacity(
                0.05,
              ),

              blurRadius: 10,

              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: BottomNavigationBar(

          backgroundColor: Colors.white,

          currentIndex: selectedIndex,

          elevation: 0,

          type:
          BottomNavigationBarType.fixed,

          selectedItemColor:
          const Color(0xFF4FC3F7),

          unselectedItemColor:
          Colors.grey,

          selectedLabelStyle:
          const TextStyle(
            fontWeight: FontWeight.bold,
          ),

          onTap: (index) {

            setState(() {
              selectedIndex = index;
            });
          },

          items: const [

            BottomNavigationBarItem(

              icon: Icon(
                Icons.account_balance_wallet_outlined,
              ),

              activeIcon: Icon(
                Icons.account_balance_wallet,
              ),

              label: "Wallet",
            ),

            BottomNavigationBarItem(

              icon: Icon(
                Icons.receipt_long_outlined,
              ),

              activeIcon: Icon(
                Icons.receipt_long,
              ),

              label: "Transactions",
            ),

            BottomNavigationBarItem(

              icon: Icon(
                Icons.settings_outlined,
              ),

              activeIcon: Icon(
                Icons.settings,
              ),

              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}