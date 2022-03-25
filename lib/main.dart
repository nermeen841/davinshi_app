import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:davinshi_app/splach.dart';
import 'BottomNavWidget/change_pass.dart';
import 'lang/change_language.dart';
import 'lang/localizations.dart';
import 'models/bottomnav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));
  await Firebase.initializeApp();
  await startShared();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({required this.appLanguage, Key? key}) : super(key: key);
  final AppLanguage appLanguage;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProvidersList.getProviders,
      child: ChangeNotifierProvider<AppLanguage>(
        create: (_) => appLanguage,
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
                  "lang": (ctx) => LangPage(),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
