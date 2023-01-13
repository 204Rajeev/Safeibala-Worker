import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saf_worker/models/worker.dart';
import 'package:saf_worker/screens/submit_task_report.dart';
import '../providers/worker_provider.dart';

class TaskTile extends StatefulWidget {
  final snap;
  const TaskTile({super.key, this.snap});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressSeperate();
  }

  int idx = 0;

  String address1 = 'ghf';
  String address2 = '';

  void addressSeperate() {
    int cnt = 0;
    for (int i = 0; i < widget.snap['address'].length; i++) {
      if (widget.snap['address'][i] == ',') cnt++;

      if (cnt == 2) {
        address1 = widget.snap['address'].substring(0, i);
        address2 = widget.snap['address']
            .substring(i + 1, widget.snap['address'].length);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //User user = Provider.of<UserProvider>(context).getUser;
    //Worker wrk = Provider.of<WorkerProvider>(context).getWorker;
    return Card(
      color: Color.fromARGB(110, 0, 140, 255),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(Icons.pin_drop_sharp),
                  const SizedBox(
                    width: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address1,
                        style: TextStyle(fontSize: 12),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        address2,
                        style: TextStyle(fontSize: 12),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(widget.snap['taskType'])
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Text(widget.snap['taskId']),
                  SizedBox(
                    width: 10,
                  ),
                  Text(widget.snap['trashSize'])
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubmitReport(
                        snap: widget.snap,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios),
              )
            ],
          ),
        ],
      ),
    );
  }
}
