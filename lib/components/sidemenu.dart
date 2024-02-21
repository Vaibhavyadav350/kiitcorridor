// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiitcorridor/components/students.dart';
import 'package:kiitcorridor/dashboard/dashboard.dart';
import 'package:kiitcorridor/screens/main_screen.dart';
import 'package:kiitcorridor/screens/postings.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            DrawerHeader(
                child: Image.asset(
              "assets/images/logo.png",
              height: 100,
              width: 100,
            )),
            DrwaerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(expandedChild: DashboardScreen())));
              },
            ),
            DrwaerListTile(
              title: "Post Openings",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(expandedChild: Posting(),)),
              );
              },
            ),
            DrwaerListTile(
              title: "Students List",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(expandedChild: StudentListPage())),
              );
              },
            ),
            DrwaerListTile(
              title: "Shortlisted",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {},
            ),
            DrwaerListTile(
              title: "Selected",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {},
            ),
            DrwaerListTile(
              title: "Profile",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {},
            ),
            DrwaerListTile(
              title: "Setting",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrwaerListTile extends StatelessWidget {
  const DrwaerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });
  final String title, svgSrc;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
