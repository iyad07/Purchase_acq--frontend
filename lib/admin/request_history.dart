import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../request_handler.dart';

class RequestAdminPage extends StatefulWidget {
  const RequestAdminPage({super.key});

  @override
  State<RequestAdminPage> createState() => RequestAdminPageState();
}

class RequestAdminPageState extends State<RequestAdminPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        if (kDebugMode) {
          print(approvedRequests[0].title);
        }
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
        title: const Text("Requests"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF007BFF),
                Color(0xFF00CFFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Declined'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return buildAdminPendingCard(context,requests, index, () {
                  approve(index);
                }, () {
                  decline(index);
                }); //from the request_list.dart
              } //pandable to fill the screen
              ),  // Pending Requests
          ListView.builder(
              shrinkWrap: true,
              itemCount: approvedRequests.length,
              itemBuilder: (context, index) {
                return buildApprovedRequestCard(context,approvedRequests, index); //from the request_list.dart
              } //pandable to fill the screen
              ),  // Approved Requests
          ListView.builder(
              shrinkWrap: true,
              itemCount: declinedRequests.length,
              itemBuilder: (context, index) {
                return buildDeclinedRequestCard(context,declinedRequests, index); //from the request_list.dart
              } //pandable to fill the screen
              ),  // Declined Requests
        ],
      ),
    );
  }
}