import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../request_handler.dart';

class PendingRequestPage extends StatefulWidget {
  const PendingRequestPage({super.key});

  @override
  State<PendingRequestPage> createState() => PendingRequestPageState();
}

class PendingRequestPageState extends State<PendingRequestPage> {
  @override
  Widget build(BuildContext context) {
    void approve(index) {
      setState(() {
        approvedRequests.insert(0, requests[index]);
        requests.remove(
          requests[index],
        );
      });
      if (kDebugMode) {
        print(approvedRequests[0].title);
      }
      Navigator.of(context).pop();
    }

    void decline(index) {
      setState(() {
        declinedRequests.insert(0, requests[index]);
        requests.remove(
          requests[index],
        );
      });
      if (kDebugMode) {
        print(declinedRequests[0].title);
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Requests"),
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
                'My Pending Requests',
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
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return buildAdminPendingCard(context,requests, index, () {
                  approve(index);
                }, () {
                  decline(index);
                });
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
