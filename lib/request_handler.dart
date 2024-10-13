import 'package:flutter/material.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_pdfview/flutter_pdfview.dart';

//variables
final TextEditingController requestTitle = TextEditingController();
final TextEditingController requestDescrip = TextEditingController();
final TextEditingController quantity = TextEditingController();
final TextEditingController deliveryPlace = TextEditingController();
final TextEditingController deliveryDate = TextEditingController();
FileManager? document;

//Objects
class FileManager {
  String? fileName;
  bool isPDF;
  File? pickedFile; // For mobile/desktop
  Uint8List? webFileBytes; // For web

  FileManager({
    required this.fileName,
    required this.isPDF,
    this.pickedFile,
    this.webFileBytes,
  });
}

class Requests {
  final String title;
  final String date;
  final String description;
  final String quantity;
  final String unitOfMeasurement;
  final String deliveryPlace;
  final String deliveryDate;
  final FileManager? document;

  Requests({
    required this.title,
    required this.date,
    required this.description,
    required this.quantity,
    required this.unitOfMeasurement,
    required this.deliveryPlace,
    required this.deliveryDate,
    this.document,
  });
}

//Lists
final List<Requests> requests = [
  Requests(
      title: "New Request",
      description: "newRequest",
      date: DateTime.now().toString(),
      quantity: "20",
      unitOfMeasurement: "cm",
      deliveryPlace: "mdmsa",
      deliveryDate: "20th",
      document: FileManager(fileName: "example.com", isPDF: false)),
  Requests(
      title: "Another Request",
      description: "secondRequest",
      date: DateTime.now().toString(),
      quantity: "15",
      unitOfMeasurement: "kg",
      deliveryPlace: "accra",
      deliveryDate: "25th",
      document: FileManager(fileName: "example.com", isPDF: false)),
];
List<Requests> approvedRequests = [];
List<Requests> declinedRequests = [];

//Preview document
void previewFileByIndex(BuildContext context, int index, requestList) {
  if (index < 0 || index >= requestList.length) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid file index')),
    );
    return;
  }

  FileManager file = requestList[index].document;

  if (kIsWeb) {
    previewFileOnWeb(context, file.webFileBytes, file.fileName!, file.isPDF);
  } else {
    previewFileOnMobile(context, file.pickedFile, file.isPDF);
  }
}

// Function to preview file on web
void previewFileOnWeb(
    BuildContext context, Uint8List? fileBytes, String fileName, bool isPDF) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'File Preview',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: fileBytes != null
            ? (isPDF
                ? const Text('PDF preview is not supported on web.')
                : Image.memory(fileBytes))
            : const Text('Preview not supported for this file type'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

// Function to preview file on mobile/desktop
void previewFileOnMobile(BuildContext context, File? pickedFile, bool isPDF) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'File Preview',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: isPDF
              ? SizedBox(
                  height: 400, // Set a height for PDF view
                  child: PDFView(
                    filePath: pickedFile!.path, // Show PDF preview
                  ),
                )
              : Image.file(pickedFile!), // Show image preview
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

//detail pop_ups
void popAdminDetails(context, requestList, index, approve, decline) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Request Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                detailRow("Title:", requestList[index].title),
                detailRow("Description:", requestList[index].description),
                detailRow("Date:", requestList[index].date),
                detailRow("Quantity:", requestList[index].quantity),
                detailRow("Unit of Measurement:",
                    requestList[index].unitOfMeasurement),
                detailRow("Delivery Place:", requestList[index].deliveryPlace),
                detailRow("Delivery Date:", requestList[index].deliveryDate),
                documentdetailRow(context, requestList, index, "Document:",
                    requestList[index].document.fileName),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: decline,
            child: const Text(
              'Decline',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: approve,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.green[500],
            ),
            child: const Text("Approve",style: TextStyle(color: Colors.white),),
          ),
        ],
      );
    },
  );
}

void popDetails(BuildContext context, requestList, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Request Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                detailRow("Title:", requestList[index].title),
                detailRow("Description:", requestList[index].description),
                detailRow("Date:", requestList[index].date),
                detailRow("Quantity:", requestList[index].quantity),
                detailRow("Unit of Measurement:",
                    requestList[index].unitOfMeasurement),
                detailRow("Delivery Place:", requestList[index].deliveryPlace),
                detailRow("Delivery Date:", requestList[index].deliveryDate),
                documentdetailRow(context, requestList, index, "Document:",
                    requestList[index].document.fileName),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget documentdetailRow(
    BuildContext context, requestList, index, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            Text(
              value,
            ),
            const SizedBox(width: 10,),
            ElevatedButton(
              onPressed: () {
                previewFileByIndex(context, index, requestList);
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.red,
              ),
              child: const Text("Preview",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

//Request Widgets
Widget buildRequestCard(BuildContext context, requestList, index) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      title: Text(requestList[index].title),
      subtitle: Text(requestList[index].description),
      trailing: Text(requestList[index].date),
      onTap: () {
        popDetails(context, requestList, index);
      },
    ),
  );
}

Widget buildPendingCard(BuildContext context, requestList, index) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      title: Text(requestList[index].title),
      subtitle: Text(requestList[index].description),
      trailing: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.green,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Submitted",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        popDetails(context, requestList, index);
      },
    ),
  );
}

Widget buildAdminPendingCard(
    BuildContext context, requestList, index, approve, decline) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      title: Text(requestList[index].title),
      subtitle: Text(requestList[index].description),
      trailing: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white30,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Pending",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        popAdminDetails(context, requestList, index, approve, decline);
      },
    ),
  );
}

Widget buildApprovedRequestCard(BuildContext context, requestList, index) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      title: Text(requestList[index].title),
      subtitle: Text(requestList[index].description),
      trailing: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.green[500],
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Approved",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        popDetails(context, requestList, index);
      },
    ),
  );
}

Widget buildDeclinedRequestCard(BuildContext context, requestList, index) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      title: Text(requestList[index].title),
      subtitle: Text(requestList[index].description),
      trailing: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.red[500],
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Declined",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        popDetails(context, requestList, index);
      },
    ),
  );
}
