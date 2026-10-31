import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApp extends StatefulWidget {
  const NotificationApp({super.key});
  @override
  State<NotificationApp> createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  final plugin = FlutterLocalNotificationsPlugin();
  bool ready = false;
  String? status;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      if (mounted) setState(() => ready = true);
    } catch (_) {
      if (mounted) {
        setState(() => status = 'Notifications unavailable on this device.');
      }
    }
  }

  Future<void> _show() async {
    try {
      final android = plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final ios = plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final permitted =
          await android?.requestNotificationsPermission() ??
          await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true;
      if (!permitted) throw StateError('Permission denied');
      await plugin.show(
        id: 1,
        title: 'Lab 10',
        body: 'Local notification works!',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'lab10_actions',
            'Account actions',
            channelDescription: 'Notifications after user actions',
            importance: Importance.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
      if (mounted) {
        setState(
          () => status = 'Notification requested. Check the system tray.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => status = 'Notification failed or permission denied.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Lab 10.5 • Local notification')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: ready ? _show : null,
              child: const Text('Show notification'),
            ),
            if (status != null) Text(status!),
          ],
        ),
      ),
    ),
  );
}
