import 'dart:io';

import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:path/path.dart';
import 'package:todoapp/screens/homepage.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Made with Flutter",
                    ),
                    Text(
                        "Author: Tang Hau Chong"
                    ),
                    LinkText(
                      "Find me at -> https://hauchongtang.github.io/#/",
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
