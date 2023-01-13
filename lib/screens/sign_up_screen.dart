import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saf_worker/models/worker.dart';
import '../utils/colors_utils.dart';
import '../widgets/reusable_widgets.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _phoneNoTextController = TextEditingController();
  TextEditingController _postalCodeTextController = TextEditingController();
  TextEditingController _localityTextController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<Worker> getUserDetails() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('Worker')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();

  //   return Worker.fromSnap(snap);
  // }

  Future<String> addUser(UserCredential value) async {
    Worker user = Worker(
        email: _emailTextController.text,
        wid: value.user!.uid,
        userName: _userNameTextController.text,
        phoneNo: _phoneNoTextController.text,
        locality: _localityTextController.text,
        postalCode: _postalCodeTextController.text
        );

    await _firestore.collection('Worker').doc(value.user!.uid).set(user.toJson());
    String res = 'Hogaya bro';
    print(res);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("7F7FD5"),
            hexStringToColor("86A8E7"),
            hexStringToColor("91EAE4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Locality", Icons.person_outline, false,
                    _localityTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Phone Number", Icons.person_outline, false,
                    _phoneNoTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter postalCode", Icons.person_outline, false,
                    _postalCodeTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    addUser(value);
                    print("Created New Account");
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ))),
    );
  }
}
