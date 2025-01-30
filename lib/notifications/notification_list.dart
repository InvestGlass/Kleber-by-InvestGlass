import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/app_widgets.dart';

import '../main.dart';
import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Portfolio Added',
      subtitle: 'Check out the latest portfolio updates.',
      icon: Icons.work_outline,
      color: Colors.blue,
      time: '2m ago',
    ),
    NotificationItem(
      title: 'New Chat Message',
      subtitle: 'You have a new message from John.',
      icon: Icons.message_outlined,
      color: Colors.green,
      time: '5m ago',
    ),
    NotificationItem(
      title: 'New Proposal Received',
      subtitle: 'You received a new project proposal.',
      icon: Icons.assignment_outlined,
      color: Colors.orange,
      time: '10m ago',
    ),
    NotificationItem(
      title: 'New Document Shared',
      subtitle: 'A new document has been shared with you.',
      icon: Icons.insert_drive_file_outlined,
      color: Colors.purple,
      time: '15m ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(context, 'Notification',leading: AppWidgets.backArrow(context)),
      body: ListView.builder(
        padding: EdgeInsets.all(rSize*0.015),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: AppStyles.shadow(),
                borderRadius: BorderRadius.circular(rSize * 0.01)),
            padding: EdgeInsets.all(rSize * 0.015),
            margin: EdgeInsets.only(bottom: rSize*0.015),
            child: ListTile(contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: item.color.withOpacity(0.2),
                child: Icon(item.icon, color: item.color),
              ),
              title: Text(item.title, style: AppStyles.inputTextStyle(context).copyWith(color: FlutterFlowTheme.of(context).primaryText)),
              subtitle: Text(item.subtitle,style: AppStyles.inputTextStyle(context),),
              trailing: Text(item.time, style: AppStyles.inputTextStyle(context)),
              onTap: () {

              },
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String time;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.time,
  });
}
