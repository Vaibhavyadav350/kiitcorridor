import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kiitcorridor/components/sidemenu.dart';
import 'package:kiitcorridor/dashboard/dashboard.dart';

import '../color.dart';
import '../components/students.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                child: SideMenu()),
            Expanded(
                flex: 5,
                child: StudentListPage())
          ],
        ),
      ),
    );
  }
}



