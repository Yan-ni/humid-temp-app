import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LinechartWidget extends StatefulWidget {
  const LinechartWidget({
    super.key,
    required this.threshold,
    Color? mainLineColor,
    Color? belowLineColor,
    Color? aboveLineColor,
  })  : mainLineColor = mainLineColor ?? Colors.blue,
        belowLineColor = belowLineColor ?? Colors.red,
        aboveLineColor = aboveLineColor ?? Colors.green;

  final String threshold;
  final Color mainLineColor;
  final Color belowLineColor;
  final Color aboveLineColor;

  @override
  State<LinechartWidget> createState() => _LinechartWidgetState();
}

class _LinechartWidgetState extends State<LinechartWidget> {
  List<FlSpot> spots = [];
  double minY = 0, maxY = 35;

  @override
  void initState() {
    super.initState();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    final DateTime today = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    final String todayPath = 'Archive/${formatter.format(today)}';

    dbRef.child(todayPath).onValue.listen((event) {
      final Map map = event.snapshot.value as Map;
      double? minYtmp, maxYtmp;
      List<FlSpot> spotsTmp = [];
      for (var entry in map.entries) {
        double x = double.parse(entry.key.replaceFirst(':', ''));
        var yValue = entry.value['Temperature'];

        if (yValue == null) {
          continue;
        }

        double? y = double.parse(yValue.toString());

        if (minYtmp == null || maxYtmp == null) {
          minYtmp = y;
          maxYtmp = y;
        }

        if (minYtmp > y) {
          minYtmp = y.floorToDouble();
        } else if (maxYtmp < y) {
          maxYtmp = y.ceilToDouble();
        }

        spotsTmp.add(FlSpot(x, y));
      }

      spotsTmp.sort((spotA, spotB) => (spotA.x - spotB.x).round());
      setState(() {
        spots = spotsTmp;
        minY = minYtmp! - 0.2;
        maxY = maxYtmp!.ceilToDouble();
      });
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;

    text = value == 2400 ? '0h' : '${(value / 100).round().toString()}h';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('${value.toStringAsFixed(1)}°', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    double cutOffYValue =
        double.parse(widget.threshold != "null" ? widget.threshold : '0');

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 20,
          top: 22,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            minX: 0,
            maxX: 2400,
            lineTouchData: const LineTouchData(enabled: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 5,
                color: widget.mainLineColor,
                belowBarData: BarAreaData(
                  show: true,
                  color: widget.belowLineColor,
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  color: widget.aboveLineColor,
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: Text(
                  'Time',
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.mainLineColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 18,
                  interval: 300,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: const Text(
                  'Temperature',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (maxY - minY) / 10,
                  reservedSize: 40,
                  getTitlesWidget: leftTitleWidgets,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.black,
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: (maxY - minY) / 10,
              verticalInterval: 300,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
            ),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: cutOffYValue,
                  color: Colors.deepPurple,
                  strokeWidth: 3,
                  dashArray: [15, 10],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
