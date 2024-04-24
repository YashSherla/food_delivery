import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  Future addUserDetails(
      {required Map<String, dynamic> userinfo, required String id}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .set(userinfo);
  }

  updateWallet({required String id, required String newFeild}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update({"Wallet": newFeild});
  }

  cartDetails(
      {required String id, required Map<String, dynamic> userinfo}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Cart")
        .add(userinfo);
  }

  Future addFoodDetails(
      {required Map<String, dynamic> userinfo, required String name}) async {
    return await FirebaseFirestore.instance.collection(name).add(userinfo);
  }

  Future<Stream<QuerySnapshot>> getFoodDetails({required String name}) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future<Stream<QuerySnapshot>> getFoodCart({
    required String id,
  }) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }
}
