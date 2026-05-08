import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  String get uid => auth.currentUser!.uid;

  // CREATE USER DATA
  Future<void> createUserData({
    required String name,
    required String email,
  }) async {
    await firestore
        .collection("users")
        .doc(uid)
        .set({
      "name": name,
      "email": email,

      // user starts with 0 coins
      "BTC": 0.0,
      "ETH": 0.0,
      "BNB": 0.0,
      "USDT": 0.0,

      "createdAt":
      FieldValue.serverTimestamp(),
    });
  }

  // GET USER DATA
  Stream<DocumentSnapshot> getUserData() {
    return firestore
        .collection("users")
        .doc(uid)
        .snapshots();
  }

  // ADD TRANSACTION
  Future<void> addTransaction({
    required String type,
    required String coinName,
    required double amount,
    required String address,
    required double coinPrice,
  }) async {
    await firestore
        .collection("transactions")
        .add({
      "uid": uid,
      "type": type,
      "coinName": coinName,
      "amount": amount,
      "address": address,
      "coinPrice": coinPrice,
      "totalValue":
      amount * coinPrice,
      "createdAt":
      FieldValue.serverTimestamp(),
    });

    // update balance
    final userRef = firestore
        .collection("users")
        .doc(uid);

    final userDoc =
    await userRef.get();

    final data =
    userDoc.data()
    as Map<String, dynamic>?;

    double currentBalance =
    (data?[coinName] ?? 0)
        .toDouble();

    if (type == "receive") {
      currentBalance += amount;
    } else {
      currentBalance -= amount;

      if (currentBalance < 0) {
        currentBalance = 0;
      }
    }

    await userRef.update({
      coinName: currentBalance,
    });
  }

  // GET TRANSACTIONS
  Stream<QuerySnapshot> getTransactions() {
    return firestore
        .collection("transactions")
        .where("uid",
        isEqualTo: uid)
        .orderBy(
      "createdAt",
      descending: true,
    )
        .snapshots();
  }
}