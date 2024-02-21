// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiitcorridor/color.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20.0),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Analytics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildAnalyticsItem(
                      context,
                      "Students Enrolled",
                      "1200", 
                      "assets/icons/Search.svg",
                    ),
                    SizedBox(height: 10),
                    _buildAnalyticsItem(
                      context,
                      "Postings Uploaded",
                      "350", 
                      "assets/icons/menu_doc.svg",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsItem(
    BuildContext context,
    String title,
    String value,
    String iconPath,
  ) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 30,
          height: 30,
          color: primaryColor, 
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor, 
              ),
            ),
          ],
        ),
      ],
    );
  }
}
