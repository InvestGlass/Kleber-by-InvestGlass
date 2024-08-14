import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kleber_bank/dashboard/dashboard.dart';
import 'package:kleber_bank/dashboard/dashboard_controller.dart';
import 'package:kleber_bank/login/login.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/portfolio/positions.dart';
import 'package:kleber_bank/portfolio/transactions.dart';
import 'package:kleber_bank/profile/profile_controller.dart';
import 'package:kleber_bank/proposals/proposal_controller.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/flutter_flow_theme.dart';
import 'package:kleber_bank/utils/internationalization.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'documents/documents_controller.dart';
import 'home/home_controller.dart';
import 'login/login_controller.dart';
import 'market/market_controller.dart';

double rSize = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.createInstance();

  await FlutterFlowTheme.initialize();

  await FFLocalizations.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => LoginController(),
      ),
      ChangeNotifierProvider(
        create: (context) => DashboardController(),
      ),
      ChangeNotifierProvider(
        create: (context) => PortfolioController(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProfileController(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProposalController(),
      ),
      ChangeNotifierProvider(
        create: (context) => MarketController(),
      ),
      ChangeNotifierProvider(
        create: (context) => DocumentsController(),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeController(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = FFLocalizations.getStoredLocale();

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  // This widget is the root of your application.

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
    FFLocalizations.storeLocale(language);
  }

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
  });

  @override
  Widget build(BuildContext context) {
    Size ksize = MediaQuery.of(context).size;
    rSize = pow((ksize.height * ksize.height) + (ksize.width * ksize.width), 1 / 2) as double;
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('vi'),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // Background color of the menu
          surfaceTintColor: Colors.white,

          textStyle: TextStyle(color: Colors.white), // Text color in menu items
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Optionally add other styles like elevation, padding, etc.
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bg),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          colorScheme: const ColorScheme(
              primary: Color(0xFF325D80),
              secondary: Color(0xFF000A13),
              onPrimary: Colors.transparent,
              onSecondary: Colors.transparent,
              brightness: Brightness.dark,
              error: Color(0xFFFF5963),
              onError: Color(0xFFFF5963),
              surface: Colors.transparent,
              onSurface: Colors.transparent),),
      home: SharedPrefUtils.instance.getString(TOKEN).isEmpty ? Login() : Dashboard(),
    );
  }
}
