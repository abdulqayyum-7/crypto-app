import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  String get uid => auth.currentUser!.uid;

  Future<void> addTransaction({
    required String type,
    required String coin,
    required double amount,
  }) async {

    await firestore
        .collection("transactions")
        .add({

      "uid": uid,
      "type": type,
      "coin": coin,
      "amount": amount,
      "time": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getTransactions() {

    return firestore
        .collection("transactions")
        .where("uid", isEqualTo: uid)
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Map<String, double>> getPortfolio() async {

    final snapshot = await firestore
        .collection("transactions")
        .where("uid", isEqualTo: uid)
        .get();

    double btc = 0;
    double eth = 0;
    double usdt = 0;

    for (var doc in snapshot.docs) {

      final data = doc.data();

      String coin = data["coin"];
      String type = data["type"];

      double amount =
      (data["amount"] as num).toDouble();

      if (coin == "BTC") {

        if (type == "receive") {
          btc += amount;
        } else {
          btc -= amount;
        }
      }

      if (coin == "ETH") {

        if (type == "receive") {
          eth += amount;
        } else {
          eth -= amount;
        }
      }

      if (coin == "USDT") {

        if (type == "receive") {
          usdt += amount;
        } else {
          usdt -= amount;
        }
      }
    }

    return {
      "BTC": btc,
      "ETH": eth,
      "USDT": usdt,
    };
  }
}