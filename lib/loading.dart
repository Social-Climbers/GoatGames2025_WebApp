import 'package:flutter/material.dart';
import 'package:goatgames25webapp/Theme.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AccentColor),
            strokeWidth: 10.0,
          ),
        ),
      ),
    );
  }
}
