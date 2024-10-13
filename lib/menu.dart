import 'package:flutter/material.dart';
import 'package:form_acquistion/login.dart';
import 'package:form_acquistion/user/analyticss.dart'; // Ensure this file exists.



class MyDrawer extends StatelessWidget {
  final TextEditingController email = TextEditingController();

  MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_2),
                SizedBox(
                  width: 10,
                ),
                Text("A C C O U N T"),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('R E P O R T S  S U M M A R Y'),
            onTap: () {
              popSendReportSummary(context); // Now `context` is properly passed
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('A N A L Y T I C S'),
            onTap: () {
              moveToAnalytics(context); // Use `context` here as well
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('L O G O U T'),
            onTap: () {
              moveToLogin(context);// Implement logout functionality here.
            },
          ),
        ],
      ),
    );
  }

  void moveToAnalytics(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => const AnalyticsPage(),
    )); // Handle analytics tap
  }
  void moveToLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => const LoginPage(),
    )); // Handle analytics tap
  }

  void popSendReportSummary(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reports Summary"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Enter Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement send report functionality here
                  },
                  child: const Text("Send Report Summary"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}


