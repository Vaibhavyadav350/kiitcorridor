import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kiitcorridor/components/sidemenu.dart';
import 'package:kiitcorridor/dashboard/dashboard.dart';
import 'package:kiitcorridor/screens/postings.dart';

import '../color.dart';
import '../components/students.dart';

class MainScreen extends StatefulWidget {
  final Widget expandedChild;
  const MainScreen({super.key, required this.expandedChild});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SideMenu _sideMenu = const SideMenu();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(child: _sideMenu),
            Expanded(
              flex: 5, 
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: widget.expandedChild,
              ))
          ],
        ),
      ),
    );
  }
}
