import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saf_worker/models/worker.dart';

class AuthMethods {
   final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<Worker> getWrkDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Worker')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    return Worker.fromSnap(snap);
  }

Future<void> signOut() async {
    await _auth.signOut();
  }
  

}