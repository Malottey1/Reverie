import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';

class DashboardStats extends StatelessWidget {
  final Map<String, dynamic> stats;

  DashboardStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatCard(value: '\GHS ${stats['earnings']}', label: 'Earnings this month'),
            StatCard(value: '${stats['total_orders']}', label: 'Total orders'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatCard(value: '${stats['active_listings']}', label: 'Active listings'),
            StatCard(value: '${stats['new_orders']}', label: 'New orders'),
          ],
        ),
      ],
    );
  }
}