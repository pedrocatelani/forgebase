import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color.fromARGB(132, 213, 212, 212),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(21, 0, 0, 0),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deck Name etc...',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(radius: 14, backgroundColor: Colors.pink),
                  CircleAvatar(radius: 14, backgroundColor: Colors.pink),
                  CircleAvatar(radius: 14, backgroundColor: Colors.pink),
                ],
              ),
              SizedBox(width: 24),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 16),
              Row(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '97',
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                  Text('SaS', style: TextStyle(fontSize: 16)),
                ],
              ),
              Spacer(),
              Column(
                spacing: 4,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Icon(
                        Icons.diamond_rounded,
                        color: Color.fromARGB(255, 245, 220, 2),
                      ),
                      Text('11'),
                      SizedBox(width: 16),
                      Icon(
                        Icons.diamond_outlined,
                        color: Color.fromARGB(255, 255, 76, 17),
                      ),
                      Text('14'),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    children: [
                      Icon(
                        Icons.people_alt,
                        color: const Color.fromARGB(255, 36, 112, 255),
                      ),
                      Text('12'),
                      SizedBox(width: 16),
                      Icon(
                        Icons.no_accounts,
                        color: Color.fromARGB(255, 255, 76, 17),
                      ),
                      Text('15'),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    children: [
                      Icon(
                        Icons.shield_sharp,
                        color: Color.fromARGB(255, 36, 112, 255),
                      ),
                      Text('13'),
                      SizedBox(width: 16),
                      Icon(
                        Icons.polymer_sharp,
                        color: Color.fromARGB(255, 255, 76, 17),
                      ),
                      Text('16'),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 24),
            ],
          ),
        ],
      ),
    );
  }
}
