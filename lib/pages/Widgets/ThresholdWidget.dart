import 'package:flutter/material.dart';

class ThresholdWidget extends StatelessWidget {
  const ThresholdWidget({super.key, required this.threshold});

  final String threshold;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange[200],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Image(image: AssetImage('images/high-temperature.png')),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Threshold',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: 28),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      threshold,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 64),
                    ),
                    const Text(
                      '°C',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 42),
                    )
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
