import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          press: () {},
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