import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MatchNotifierService {
  static final MatchNotifierService _instance = MatchNotifierService._internal();
  factory MatchNotifierService() => _instance;
  MatchNotifierService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _timer;
  List<dynamic> _previousList = [];

  Future<void> init() async {
    // ✅ iOS-specific settings
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _notificationsPlugin.initialize(initSettings);

    // Request permissions manually (iOS)
    if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void start() {
    _fetchUsers();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) => _fetchUsers());
  }

  void stop() {
    _timer?.cancel();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:8080/api/matched-users?id=1"), headers: {
        'Content-Type': 'application/json',
        'user-id': '1',
      });
      if (response.statusCode == 200) {
        print('Matches fetched: ${response.body}');
        final dynamic body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        if (data.length > _previousList.length) {
          int newCount = data.length - _previousList.length;
          _showNotification(
              "New Match ❤️", "You have $newCount new interested user(s)!");
        }

        _previousList = data;
      }
    } catch (e) {
      print("Polling error: $e");
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'matches_channel',
      'Matches',
      channelDescription: 'Notifies when new matches appear',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.show(0, title, body, details);
  }
}
