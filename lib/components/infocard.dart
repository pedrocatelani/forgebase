import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.cardTitle,
    required this.info,
    required this.icon,
  });
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
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text(
            cardTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          icon,
          Spacer(),
          Text(
            info,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
