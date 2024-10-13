import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_acquistion/menu.dart';
import '../../request_handler.dart';
import '../pending_request.dart';
import '../request_history.dart';

class MobileDesign extends StatefulWidget {
  const MobileDesign({super.key});

  @override
  State<MobileDesign> createState() => _MobileDesignState();
}

class _MobileDesignState extends State<MobileDesign> {
  @override
  Widget build(BuildContext context) {
    void updateRequests() {
      setState(() {});
    }

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
      Navigator.of(context).pop();
      if (kDebugMode) {
        print(declinedRequests[0].title);
      }
    }

    final List<Map<String, dynamic>> requestItems = [
      {
        "title": "Approve Request",
        "subtitle": "Approve or decline a request",
        "onclick": () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const PendingRequestPage(),
          )).then((_) => updateRequests());
        },
      },
      {
        "title": "Request History",
        "subtitle": "Check request history",
        "onclick": () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const RequestAdminPage(),
          )).then((_) => updateRequests());
        },
      }
    ];

    return Scaffold(
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: const Text(
          'TotalEnergies',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('../assets/logo.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a request and submit for approval.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requestItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  return _buildHoverCard(
                    requestItems[index]['title']!,
                    requestItems[index]['subtitle']!,
                    requestItems[index]['onclick'],
                  );
                },
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Recent Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const RequestAdminPage(),
                        ),
                      );
                      // Handle see all action
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined
                      ,color: Colors.redAccent,
                    ),
                    // redAccent icon for "See all"
                    label: const Text(
                      'See all',
                      // redAccent text
                    ),
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                          Colors.red), // redAccent for the button
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return buildAdminPendingCard(context, requests, index, () {
                      approve(index);
                    }, () {
                      decline(index);
                    });
                  } //pandable to fill the screen
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // Hover card implementation
  Widget _buildHoverCard(String title, String subtitle, Function()? onClick) {
    bool isHovered = false;

    return StatefulBuilder(builder: (context, setState) {
      return MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: isHovered ? Colors.red : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: InkWell(
            onTap: onClick,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: isHovered
                          ? const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                          : const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: isHovered
                        ? const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          )
                        : const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
