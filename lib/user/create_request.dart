// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../request_handler.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateRequestPage extends StatefulWidget {
  const CreateRequestPage({super.key});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  String? _selectedValue;

  void addtoRequests(BuildContext context) {
    if (requestTitle.text.isEmpty ||
        requestDescrip.text.isEmpty ||
        quantity.text.isEmpty ||
        deliveryPlace.text.isEmpty ||
        deliveryDate.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill out all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit the function if fields are empty
    }
    setState(() {
      requests.insert(
        0,
        Requests(
          title: requestTitle.text,
          date: DateTime.now().toString(),
          description: requestDescrip.text,
          quantity: quantity.text,
          unitOfMeasurement: _selectedValue.toString(),
          deliveryPlace: deliveryPlace.text,
          deliveryDate: deliveryDate.text,
          document: document,
        ),
      );
    });
    _clearInputFields();
    Navigator.of(context).pop();
  }

  void _clearInputFields() {
    requestTitle.clear();
    requestDescrip.clear();
    quantity.clear();
    deliveryPlace.clear();
    deliveryDate.clear();
  }

  Widget _buildDropdown(String label) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: label,
        fillColor: Colors.red.withOpacity(0.1),
        filled: true,
      ),
      value: _selectedValue,
      items: const [
        DropdownMenuItem(
          value: "centimeter",
          child: Text("cm"),
        ),
        DropdownMenuItem(
          value: "meters",
          child: Text("m"),
        ),
        DropdownMenuItem(
          value: "milimeters",
          child: Text("mm"),
        ),
      ],
      onChanged: (newValue) {
        setState(() {
          _selectedValue = newValue;
        });
      },
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.red,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: hintText,
        fillColor: Colors.red.withOpacity(0.1),
        filled: true,
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      deliveryDate.text = picked.toString();
    }
  }

  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'png',
          'pdf'
        ], // Only accept specific file types
      );

      if (result != null) {
        String fileName = result.files.single.name;
        bool isPDF = fileName.endsWith('.pdf');

        if (kIsWeb) {
          Uint8List? webFileBytes = result.files.single.bytes;

          // Store the file info in the list (for web)
          setState(() {
            document = FileManager(
              fileName: fileName,
              isPDF: isPDF,
              webFileBytes: webFileBytes,
            );
          });
        } else {
          File pickedFile = File(result.files.single.path!);

          // Store the file info in the list (for mobile/desktop)
          setState(() {
            document = FileManager(
              fileName: fileName,
              isPDF: isPDF,
              pickedFile: pickedFile,
            );
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Widget _buildDatePicker(
      String hintText, TextEditingController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          cursorColor: Colors.red,
          decoration: InputDecoration(
            icon: const Icon(Icons.date_range_outlined),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            hintText: hintText,
            fillColor: Colors.redAccent.withOpacity(0.1),
            filled: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: constraints.maxWidth > 500
                        ? 500
                        : constraints.maxWidth, // Responsive width
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth >500 ? 500 :constraints.maxWidth,
                            child: const Text(
                              'Create Request',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField("Request Title", requestTitle),
                          const SizedBox(height: 16),
                          _buildTextField(
                              "Request Description", requestDescrip),
                          const SizedBox(height: 16),
                          _buildTextField("Quantity", quantity),
                          const SizedBox(height: 16),
                          _buildDropdown("Unit of Measurement"),
                          const SizedBox(height: 16),
                          _buildTextField("Delivery Place", deliveryPlace),
                          const SizedBox(height: 16),
                          _buildDatePicker(
                              "Delivery Date", deliveryDate, context),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              pickFile(context);
                            },
                            icon: const Icon(
                              Icons.attach_file_sharp,
                              color: Colors.red,
                            ),
                            label: const Text(
                              "Attach Document",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () {
                                  addtoRequests(context);
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
