import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.data});
  final Map<dynamic, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () => Navigator.pushReplacementNamed(
            context,
            '/deck',
            arguments: {"id": data["id"]},
          ),
      child: Container(
        height: 166,
        decoration: BoxDecoration(
          color: const Color.fromARGB(202, 73, 72, 72),
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
                Expanded(
                  child: Text(
                    data['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      onBackgroundImageError:
                          (_, __) => debugPrint('Erro ao carregar a imagem'),
                      backgroundImage: AssetImage(
                        "assets/houses/${data['housesNames'][0].toLowerCase()}.png",
                      ),
                    ),
                    CircleAvatar(
                      radius: 14,
                      onBackgroundImageError:
                          (_, __) => debugPrint('Erro ao carregar a imagem'),
                      backgroundImage: AssetImage(
                        'assets/houses/${data['housesNames'][1].toLowerCase()}.png',
                      ),
                    ),
                    CircleAvatar(
                      radius: 14,
                      onBackgroundImageError:
                          (e, x) => debugPrint(e.toString() + x.toString()),
                      backgroundImage: AssetImage(
                        'assets/houses/${data['housesNames'][2].toLowerCase()}.png',
                      ),
                    ),
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
                      '${data['sas']}',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
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
                        Text('${data['expectedAember'].toStringAsFixed(0).padLeft(2, "0").padLeft(3, ' ')}'),
                        SizedBox(width: 16),
                        Icon(
                          Icons.diamond_outlined,
                          color: Color.fromARGB(255, 255, 76, 17),
                        ),
                        Text('${data['aemberControl'].toStringAsFixed(0).padLeft(2, "0").padLeft(3, ' ')}'),
                      ],
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.people_alt,
                          color: const Color.fromARGB(255, 36, 112, 255),
                        ),
                        Text('${data['effectivePower'].toStringAsFixed(0).padLeft(2, "0").padLeft(3, ' ')}'),
                        SizedBox(width: 16),
                        Icon(
                          Icons.no_accounts,
                          color: Color.fromARGB(255, 255, 76, 17),
                        ),
                        Text('${data['creatureControl'].toStringAsFixed(0).padLeft(2, "0").padLeft(3, ' ')}'),
                      ],
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.shield_sharp,
                          color: Color.fromARGB(255, 36, 112, 255),
                        ),
                        Text('${data['creatureProtection'].toStringAsFixed(0).padLeft(2, "0").padLeft(3, ' ')}'),
                        SizedBox(width: 16),
                        Icon(
                          Icons.polymer_sharp,
                          color: Color.fromARGB(255, 255, 76, 17),
                        ),
                        Text('${data['disruption'].toStringAsFixed(0).padLeft(2, "0").padLeft(3, ' ')}'),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
