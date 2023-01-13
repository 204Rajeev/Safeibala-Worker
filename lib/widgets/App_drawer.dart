import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';
import '../screens/login_screen.dart';
import '../utils/utility.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Text(
            'welcome',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        ListTile(
          title: const Text('Sign Out'),
          onTap: () async {
            await AuthMethods().signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
            showSnackBar(context, 'See You Soon');
          },
        ),
        const Divider(),
      ],
    );
  }
}
