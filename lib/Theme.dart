import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Color AccentColor = Color.fromARGB(255, 234, 136, 0);

class SponsorBox extends StatelessWidget {
  SponsorBox();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.95,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var logo in [
            'assets/evolv.png',
            'assets/ag.png',
            'assets/poda.png',
            'assets/vat.png',
            'assets/mojo.png',
            'assets/zelt.png',
          ])
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                logo,
                height: size.width * 0.1,
                width: size.width * 0.1,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
