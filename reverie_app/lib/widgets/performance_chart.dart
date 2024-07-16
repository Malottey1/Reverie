import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceChart extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final List<FlSpot> dataPoints;

  PerformanceChart({
    required this.title,
    required this.value,
    required this.change,
    required this.dataPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF69734E),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'This Month $change',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: change.startsWith('+') ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 200,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Color(0xFF69734E), width: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                gridData: FlGridData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceCharts extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;

  PerformanceCharts({required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: chartData.map((data) {
        return PerformanceChart(
          title: data['title'],
          value: data['value'],
          change: data['change'],
          dataPoints: data['dataPoints'],
        );
      }).toList(),
    );
  }
}