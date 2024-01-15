import 'package:flutter/material.dart';

class CustomInfoWindow extends StatelessWidget {
  final String licensePlate;
  final String violation;
  final String date;

  const CustomInfoWindow({
    super.key,
    required this.licensePlate,
    required this.violation,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('车牌号: $licensePlate', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('违章: $violation'),
          Text('日期: $date'),
        ],
      ),
    );
  }
}
