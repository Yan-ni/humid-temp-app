import 'package:flutter/material.dart';
import 'package:humidtemp/pages/Widgets/HumidTempWidget.dart';
import 'package:humidtemp/pages/Widgets/LinechartWidget.dart';
import 'package:humidtemp/pages/Widgets/ThresholdWidget.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String threshold = '0';

  @override
  void initState() {
    super.initState();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    dbRef.child('Threshold').onValue.listen((event) {
      setState(() => threshold = event.snapshot.value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController thresholdTextFieldController =
        TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: appBar(),
      floatingActionButton:
          floatingActionButton(thresholdTextFieldController, context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: Column(
            children: [
              ThresholdWidget(threshold: threshold),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Realtime data',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const HumidTempWidget(),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Today\'s temperature chart',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              LinechartWidget(
                threshold: threshold,
              )
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton floatingActionButton(
      TextEditingController thresholdTextFieldController,
      BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        thresholdTextFieldController.text = threshold;
        showDialog(
            context: context,
            builder: (context) =>
                editTheresholdDialog(thresholdTextFieldController, context));
      },
      label: const Text('Edit Threshold'),
      icon: const Icon(Icons.edit),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Humid Temp App',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
    );
  }

  SimpleDialog editTheresholdDialog(
      TextEditingController thresholdTextFieldController,
      BuildContext context) {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return SimpleDialog(
      title: const Text('Edit Threshold'),
      contentPadding: const EdgeInsets.all(20),
      children: [
        TextField(
            keyboardType: TextInputType.number,
            controller: thresholdTextFieldController),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  dbRef.update({
                    "Threshold":
                        double.parse(thresholdTextFieldController.text),
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Save')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'))
          ],
        )
      ],
    );
  }
}
