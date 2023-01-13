import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks {
  final String? taskId;
  final String? latitude;
  final String? longitude;
  final String? wid;
  final String? userName;
  final String? taskType;
  final String? trashSize;
  final String? postUrl;
  final String? postalCode;
  final String? workerName;
  final String? address;

  Tasks(
      {this.taskId,
      this.latitude,
      this.longitude,
      this.wid,
      this.taskType,
      this.trashSize,
      this.postUrl,
      this.postalCode,
      this.address,
      this.workerName,
      this.userName});

  static Tasks fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Tasks(
      userName: snapshot['userName'],
      workerName: snapshot['workerName'],
      wid: snapshot['wid'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
      trashSize: snapshot['trashSize'],
      taskType: snapshot['taskType'],
      address: snapshot['address'],
      taskId: snapshot['taskId'],
      postUrl: snapshot['postUrl'],
      postalCode: snapshot['postalCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'workerName': workerName,
        'wid': wid,
        'latitude': latitude,
        'longitude': longitude,
        'trashSize': trashSize,
        'taskType': taskType,
        'taskId': taskId,
        'postUrl': postUrl,
        'postalCode': postalCode,
        'address': address,
      };
}
