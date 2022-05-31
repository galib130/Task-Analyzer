import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proda/HeartRate/HeartRate.dart';
import 'package:proda/authentication/backendservice.dart';
import 'package:proda/globalstatemanagement/ChangeState.dart';
import 'package:proda/home%20screen/CompleteListView.dart';
// import 'package:jarvia/open.dart';
import 'authentication/open.dart';
import 'home screen/TestApp.dart';
import 'package:provider/provider.dart';
// import 'open.dart';
import 'authentication/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'charts/chart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'charts/average_chart.dart';
import 'dart:async';
import 'home screen/TestAppState.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true);

Future<void> _firebaseMassagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseAuth auth = FirebaseAuth.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String uid = auth.currentUser!.uid;
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  tz.initializeTimeZones();
  final locationName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(locationName));

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  });

  tz.initializeTimeZones();
  final Future<FirebaseApp> fbapp = Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(
      providers: [
        Provider<FlutterFireAuthService>(
          create: (_) => FlutterFireAuthService(FirebaseAuth.instance),

          // builder: (context) => FlutterFireAuthService(_firebaseAuth),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FlutterFireAuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => ChangeState())
      ],
      builder: (context, _) {
        return MyApp();
      }));
}

class User_class {
  List<String>? name;
  int flag;
  User_class(this.name, this.flag);
}

List<String> li = <String>['Do laundry'];

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/profile': (context) => TestApp(),
        '/openview': (context) => OpenView(),
        '/myapp': (context) => MyApp(),
        '/chart': (context) => Session(),
        '/average_chart': (context) => Average_Session(),
        '/completed': (context) => CompletedListView(),
        '/heartbeat': (context) => HeartBeat()
      },
      title: 'Welcome to jarvia',
      home: OpenView(),
    );

// ok
  }
}
