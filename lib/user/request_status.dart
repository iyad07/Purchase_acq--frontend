import 'package:flutter/material.dart';

import '../request_handler.dart';

class RequestStatusPage extends StatefulWidget {
  const RequestStatusPage({super.key});

  @override
  State<RequestStatusPage> createState() => RequestStatusPageState();
}

class RequestStatusPageState extends State<RequestStatusPage> with SingleTickerProviderStateMixin {
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
                return buildPendingCard(context,requests, index); //from the request_list.dart
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