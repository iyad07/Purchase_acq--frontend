import 'package:flutter/material.dart';
import '../request_handler.dart';

class ApprovedRequestPage extends StatefulWidget {
  const ApprovedRequestPage({super.key});

  @override
  State<ApprovedRequestPage> createState() => ApprovedRequestPageState();
}

class ApprovedRequestPageState extends State<ApprovedRequestPage> {
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Approved Requests"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF007BFF), // Blue color from the logo
                Color(0xFF00CFFF), // Lighter blue for gradient effect
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Approved Requests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: approvedRequests.length,
                  itemBuilder: (context, index) {
                    return buildApprovedRequestCard(context,approvedRequests, index);
                  },
                ), // Make Recents expandable to fill the screen
              ),
            ],
          ),
        ),
      ),
    );
  }
}
