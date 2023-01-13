import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saf_worker/models/worker.dart';
import 'package:saf_worker/resources/auth_methods.dart';
import 'package:saf_worker/resources/make_tasks.dart';
import 'package:saf_worker/screens/submit_task_report.dart';
import 'package:saf_worker/widgets/App_drawer.dart';

import '../providers/worker_provider.dart';
import '../widgets/task_til.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  late WorkerProvider _userProvider;

  addData() async {
    _userProvider = Provider.of<WorkerProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    Worker wrk = Provider.of<WorkerProvider>(context).getWorker;

    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Color.fromARGB(210, 255, 255, 255),
        child: AppDrawer(),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 1, 174, 255)),
        backgroundColor: Colors.white,
        title: const Text('Work Todo', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('worktask')
            .where('wid', isEqualTo: wrk.wid)
            .snapshots(),
        //FirebaseFirestore.instance.collection('worktask').snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: TaskTile(
                  snap: //snapshot.data!.docs[index].data(),
                      snapshot.data!.docs[index].data()),
            ),
          );
        }),
      ),
    );
  }
}
