import 'package:flutter/material.dart';

class InfoCardWidget extends StatefulWidget {
  const InfoCardWidget({
    super.key,
    required this.color,
    required this.imagePath,
    required this.value,
    required this.title,
  });

  final Color color;
  final String imagePath;
  final String value;
  final String title;

  @override
  State<InfoCardWidget> createState() => _InfoCardWidgetState();
}

class _InfoCardWidgetState extends State<InfoCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xBBD6B64C),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image(
                  width: 50,
                  height: 50,
                  image: AssetImage(widget.imagePath),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                widget.value,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(widget.title),
            )
          ],
        ),
      ),
    );
  }
}
