import 'package:flutter/material.dart';
import 'package:humidtemp/pages/Widgets/subWidgets/InfoCardWidget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';

class HumidTempWidget extends StatefulWidget {
  const HumidTempWidget({super.key});

  @override
  State<HumidTempWidget> createState() => _HumidTempWidgetState();
}

class _HumidTempWidgetState extends State<HumidTempWidget> {
  double humidity = 0;
  String temperature = '0';

  @override
  void initState() {
    super.initState();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    dbRef.child("Temperature").onValue.listen((event) =>
        setState(() => temperature = event.snapshot.value.toString()));

    dbRef.child("Humidity").onValue.listen((event) {
      String humidityStr = event.snapshot.value.toString();
      setState(() {
        if (humidityStr == 'null') {
          humidity = 0.0;
        }
        // if the humidity is a round number, firebase stores it as an int.
        try {
          humidity = double.parse(humidityStr);
        } catch (e) {
          int humidityInt = int.parse(humidityStr);
          humidity = humidityInt.toDouble();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var temperatureWidget = InfoCardWidget(
        color: const Color(0xDFFFD64F),
        imagePath: 'images/thermometer.png',
        value: '$temperature°C',
        title: 'Temperature');

    var humidityWidget = Material(
      color: Colors.lightBlue[100],
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
        child: CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 13.0,
          animateFromLastPercent: true,
          percent: humidity,
          center: Text(
            "${(double.parse(humidity.toString()) * 100).round()}%",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
          ),
          footer: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Humidity",
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.blue[600],
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          temperatureWidget,
          humidityWidget,
        ]),
      ),
    );
  }
}
