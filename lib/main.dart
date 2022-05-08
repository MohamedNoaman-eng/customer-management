

import 'package:dcache/dcache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/provider/carsProvider.dart';
import 'package:zain/provider/category_provider.dart';
import 'package:zain/provider/clientProvider.dart';
import 'package:zain/provider/clientdetailsProvider.dart';
import 'package:zain/provider/driver_provider.dart';
import 'package:zain/provider/leaderProvider.dart';
import 'package:zain/provider/officerProvider.dart';
import 'package:zain/provider/orderProvider.dart';
import 'package:zain/provider/productProvider.dart';
import 'package:zain/provider/providerState.dart';
import 'package:zain/screen/cars/driver_journey.dart';
import 'screen/Sales_team/add_leader.dart';
import 'screen/Sales_team/add_officer.dart';
import 'screen/orders/add_order.dart';
import 'package:zain/screen/cars/add_driver.dart';
import 'package:zain/screen/home.dart';
import 'screen/Auth/login.dart';
import 'screen/orders/orderScreen.dart';
import 'screen/orders/order_details.dart';
import 'screen/Products_Categpries/products.dart';
import 'screen/clients/registerClient.dart';
import 'screen/Auth/wrapper.dart';
import 'database_services/auth.dart';
import 'localization/localization.dart';
import 'localization/localization_constants.dart';
import 'models/user.dart';



void main() {

  runApp(
    MultiProvider( providers: [
      ChangeNotifierProvider(create: (context) => AppProvider()),
      ChangeNotifierProvider(create: (context) => ClientDetailsProvider()),
      ChangeNotifierProvider(create: (context) => ProductProvider()),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => OfficerProvider()),
      ChangeNotifierProvider(create: (context) => ClientProvider()),
      ChangeNotifierProvider(create: (context) => DriverProvider()),
      ChangeNotifierProvider(create: (context) => CarsProvider()),
      ChangeNotifierProvider(create: (context) => LeaderProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()..getAllClients()..getAllCategories()..getAllProducts()),
    ],
    child: MyApp(),)
  );

}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  // ignore: must_call_super
  void initState() {

    getLocal();
  }

  @override
  void didChangeDependencies() {
    LocalizationConst.getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }
  getLocal() {
    LocalizationConst.getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserDetails>(
        create: (context) => AuthService().user,
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute:"/login",
          title: "Zain Company",
          theme: ThemeData(
            primaryColor: Color.fromRGBO(255, 0, 0, 1),
            accentColor: Colors.white,
          ),
          routes: {
             '/home': (BuildContext context) => Home(),
            '/login': (BuildContext context) => Login(),
            '/register': (BuildContext context) => RegisterClient(),
             '/products': (BuildContext context) => ProductsScreen(),
            '/orderScreen': (BuildContext context) => AddOrderScreen(),
            '/showOrders': (BuildContext context) => MyOrder(),
            '/orderDetails': (BuildContext context) => OrderDetails(),
            '/addOfficer': (BuildContext context) => AddOfficer(),
            '/addLeader': (BuildContext context) => AddLeader(),
             '/driverJourney': (BuildContext context) => DriverJourney(),
            // "/cartItems": (BuildContext context) => CartItems()
          },
          locale: _locale,
          supportedLocales: [
            const Locale('en', 'US'), // English
            const Locale('ar', 'EG'), // Arabic
          ],
          localizationsDelegates: [
            // ... app-specific localization delegate[s] here
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            Localization.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocals) {
            for (var locale in supportedLocals) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocals.first;
          },
        )
    );
  }
}
