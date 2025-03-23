import 'package:flutter/material.dart';
import 'package:goatgames25webapp/Theme.dart';

class ButtonBox extends StatelessWidget {
  final VoidCallback onTap;
  final String? label;
  final IconData? icon;

  const ButtonBox({required this.onTap, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: label == null ? 100 : MediaQuery.of(context).size.width * 0.9,
        height: label == null ? 100 : MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          shape: label == null ? BoxShape.circle : BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage('assets/button_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:
              label != null
                  ? Text(label!, style: TextStyle(color: Colors.black))
                  : Icon(icon, color: Colors.black),
        ),
      ),
    );
  }
}
