import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.cardTitle, required this.info, required this.icon});
  final String cardTitle;
  final String info;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(8),
      height: 40,
      child: Row(
        spacing: 4,
        children: [
          Text(
            cardTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          icon,
          Text(
            info,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
