import 'package:flutter/material.dart';
import 'package:freerasp/freerasp.dart';
import 'package:kleber_bank/utils/app_widgets.dart';

/// ListView displaying all detected threats
class ThreatListView extends StatelessWidget {
  /// Represents a list of detected threats
  const ThreatListView({
    required this.threats,
    super.key,
  });

  /// Set of detected threats
  final Set<Threat> threats;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: Threat.values.length,
      itemBuilder: (context, index) {
        final currentThreat = Threat.values[index];
        final isDetected = threats.contains(currentThreat);

        return ListTile(
          title: Text(currentThreat.name.toUpperCase()),
          subtitle: Text(isDetected ? 'Danger' : 'Safe'),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
    );
  }
}
