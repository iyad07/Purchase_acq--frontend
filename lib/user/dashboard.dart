import 'package:flutter/material.dart';
import 'package:form_acquistion/user/dash_reposivedesigns/desktop_design.dart';
import 'package:form_acquistion/user/dash_reposivedesigns/mobile_design.dart';
import 'package:form_acquistion/user/dash_reposivedesigns/tablet_design.dart';
import 'package:form_acquistion/responsive.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileDesign: MobileDesign(),
      tabletDesign: TabletDesign(),
      desktopDesign: DesktopDesign(),
    );
  }
}
