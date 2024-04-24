import 'package:flutter/material.dart';

class GobalWidgets {
  static TextStyle mainText() {
    return TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  }

  Widget imageConatiner(String imageUrl, Color color, Color imgColor) {
    return Card(
      child: Container(
        
        color: color,
        padding: const EdgeInsets.all(8),
        child: Image.network(
          imageUrl,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          color: imgColor,
        ),
      ),
    );
  }
}
