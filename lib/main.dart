// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:davinshi_app/provider/notification.dart';
import 'package:davinshi_app/splach.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:davinshi_app/app_config/providers.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/screens/address/address.dart';
import 'package:davinshi_app/screens/cart/orders.dart';
import 'package:davinshi_app/screens/home_folder/home_page.dart';
import 'package:davinshi_app/screens/lang.dart';
import 'package:davinshi_app/screens/noti.dart';
import 'package:davinshi_app/screens/product_info/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BottomNavWidget/change_pass.dart';
import 'lang/change_language.dart';
import 'lang/localizations.dart';
import 'models/bottomnav.dart';
import 'models/order.dart';
import 'screens/cart/order_info.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ');
}

////////////////////////////////////////////////////////////////////////////////////////////////
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
///////////////////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));
  await Firebase.initializeApp();
  await startShared();
  final token = await FirebaseMessaging.instance.getToken();
  SharedPreferences _sp = await SharedPreferences.getInstance();
  _sp.setString('token', "$token").then((value) {
    notificationToken();
  });
  print(token);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  const MyApp({required this.appLanguage, Key? key}) : super(key: key);
  final AppLanguage appLanguage;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("55555555555555555555555555555555555555555555555555555555555");
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    icon: 'launch_background', importance: Importance.high),
              ));
        }

        var val;
        var data = message.data;
        print(data);
        if (message.data.containsKey('a_data')) {
          if (data['a_data']['type'] == "Product") {
            navPR(
              context,
              Products(
                fromFav: false,
                productId: data['a_data']['type_id'],
              ),
            );
          } else if (data['a_data']['type'] == "Order") {
            dialog(context);
            getOrder(data['a_data']['type_id']).then((value) {
              if (value) {
                navPR(
                    context,
                    OrderInfo(
                      orderClass: orders[0],
                    ));
              } else {
                navPop(context);
                error(context);
              }
            });
          } else if (data['a_data']['type_id'] == "Brand") {
          } else if (data['a_data']['type_id'] == "Category") {}
        }

        print("firebase data ----------------------------- : $val");
        debugPrint("firebase data ----------------------------- : $val");
        debugPrint(
            "firebase type ----------------------------- : ${message.data['type']}");
      }
    });
////////////////////////////////////////////////////////////////////////////////////////////////////////
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  icon: 'launch_background', importance: Importance.high),
            ));
      }

      var val;
      var data = message.data;
      print(data);
      if (message.data.containsKey('a_data')) {
        if (data['a_data']['type'] == "Product") {
          navPR(
            context,
            Products(
              fromFav: false,
              productId: data['a_data']['type_id'],
            ),
          );
        } else if (data['a_data']['type'] == "Order") {
          dialog(context);
          getOrder(data['a_data']['type_id']).then((value) {
            if (value) {
              navPR(
                  context,
                  OrderInfo(
                    orderClass: orders[0],
                  ));
            } else {
              navPop(context);
              error(context);
            }
          });
        } else if (data['a_data']['type_id'] == "Brand") {
        } else if (data['a_data']['type_id'] == "Category") {}
      }

      print("firebase data ----------------------------- : $val");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      var val;
      var data = message.data;
      print(data);
      if (message.data.containsKey('a_data')) {
        if (data['a_data']['type'] == "Product") {
          navPR(
            context,
            Products(
              fromFav: false,
              productId: data['a_data']['type_id'],
            ),
          );
        } else if (data['a_data']['type'] == "Order") {
          dialog(context);
          getOrder(data['a_data']['type_id']).then((value) {
            if (value) {
              navPR(
                  context,
                  OrderInfo(
                    orderClass: orders[0],
                  ));
            } else {
              navPop(context);
              error(context);
            }
          });
        } else if (data['a_data']['type_id'] == "Brand") {
        } else if (data['a_data']['type_id'] == "Category") {}
      }

      print("firebase data ----------------------------- : $val");
    });
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
        }
        break;
      case 'unsubscribe':
        {
          print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            print('FlutterFire Messaging Example: Getting APNs token...');
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            print('FlutterFire Messaging Example: Got APNs token: $token');
          } else {
            print(
                'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProvidersList.getProviders,
      child: ChangeNotifierProvider<AppLanguage>(
        create: (_) => widget.appLanguage,
        child: Consumer<AppLanguage>(
          builder: (context, lang, _) {
            return AnnotatedRegion(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    systemOverlayStyle: st,
                  ),
                  primaryColor: Colors.black,
                  checkboxTheme: CheckboxThemeData(
                    checkColor: MaterialStateProperty.all<Color>(Colors.white),
                    fillColor: MaterialStateProperty.all<Color>(mainColor),
                  ),
                  fontFamily: 'Tajawal',
                ),
                home: Splach(),
                locale: lang.appLocal,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ar', 'EG'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routes: {
                  "pro": (ctx) => const Products(
                        fromFav: false,
                        brandId: 0,
                      ),
                  "noti": (ctx) => Notifications(),
                  "home": (ctx) => Home(),
                  "change": (ctx) => ChangePass(),
                  "address": (ctx) => Address(),
                  "orders": (ctx) => const Orders(),
                  "lang": (ctx) => const LangPage(),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
