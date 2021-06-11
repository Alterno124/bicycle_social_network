import 'package:bicycle_social_network/views/View_home.dart';
import 'package:bicycle_social_network/views/View_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        FirebaseApp firebaseApp = await Firebase.initializeApp();
        User user = FirebaseAuth.instance.currentUser;
        String id;
        String imagen;
        String descripcion;
        message.data.forEach((key, value) {
          id = value;
        });
        FirebaseFirestore.instance
            .collection("UsersBikes")
            .doc(id)
            .get()
            .then((value) {
          imagen = value.data()["imagen_Bicicleta_1"];
          descripcion = value.data()["descripcion"];
          print("La imagen" + imagen);
          print("La descripcion" + descripcion);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => Home(
                detailsUser: user,
                id_robo: id,
                imagen: imagen,
                descripcion: descripcion,
              ),
            ),
          );
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        FirebaseApp firebaseApp = await Firebase.initializeApp();
        User user = FirebaseAuth.instance.currentUser;
        String id;
        String imagen;
        String descripcion;
        message.data.forEach((key, value) {
          id = value;
        });
        FirebaseFirestore.instance
            .collection("UsersBikes")
            .doc(id)
            .get()
            .then((value) {
          imagen = value.data()["imagen_Bicicleta_1"];
          descripcion = value.data()["descripcion"];
          print("La imagen" + imagen);
          print("La descripcion" + descripcion);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => Home(
                detailsUser: user,
                id_robo: id,
                imagen: imagen,
                descripcion: descripcion,
              ),
            ),
          );
        });
        /*showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return user == null ? OnboardingScreen() : Home(detailsUser: user);
  }
}
