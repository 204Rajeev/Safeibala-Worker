import 'package:cloud_firestore/cloud_firestore.dart';

class Worker {
  final String email;
  final String wid;
  final String userName;
  final String locality;
  final String postalCode;
  final String phoneNo;

  const Worker({
    required this.email,
    required this.wid,
    required this.userName,
    required this.locality,
    required this.postalCode,
    required this.phoneNo,
  });

  Map<String, dynamic> toJson() => {
        'username': userName,
        'wid': wid,
        'email': email,
        'locality': locality,
        'postalCode': postalCode,
        'phoneNo': phoneNo
      };

  static Worker fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Worker(
      userName: snapshot['username'],
      wid: snapshot['wid'],
      email: snapshot['email'],
      phoneNo: snapshot['phoneNo'],
      locality: snapshot['locality'],
      postalCode: snapshot['postalCode'],
    );
  }
}
