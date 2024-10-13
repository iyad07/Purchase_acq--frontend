import 'package:flutter/material.dart';
import 'package:form_acquistion/admin/Admindashresponsive/desktop_design.dart';
import 'package:form_acquistion/admin/Admindashresponsive/mobile_design.dart';
import 'package:form_acquistion/admin/Admindashresponsive/tablet_design.dart';
import 'package:form_acquistion/responsive.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileDesign: MobileDesign(),
      tabletDesign: TabletDesign(),
      desktopDesign: DesktopDesign(),
    );}
}
