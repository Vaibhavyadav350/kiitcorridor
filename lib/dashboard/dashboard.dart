// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiitcorridor/color.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Dashboard",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                      fillColor: secondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: SvgPicture.asset("assets/icons/Search.svg"),
                      )),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
