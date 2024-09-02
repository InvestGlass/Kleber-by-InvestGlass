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
import 'package:kleber_bank/securitySelection/security_selection_controller.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/flutter_flow_theme.dart';
import 'package:kleber_bank/utils/internationalization.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'documents/documents_controller.dart';
import 'home/home_controller.dart';
import 'login/login_controller.dart';
import 'login/on_boarding_page_widget.dart';
import 'main_controller.dart';
import 'market/market_controller.dart';

double rSize = 0;
late BuildContext globalContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.createInstance();

  await FlutterFlowTheme.initialize();

  await FFLocalizations.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => MainController(),
      ),
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
      ChangeNotifierProvider(
        create: (context) => SecuritySelectionController(),
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
  late MainController _notifier;

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
    _notifier=Provider.of<MainController>(context);
    globalContext=context;
    Size ksize = MediaQuery.of(context).size;
    rSize = pow((ksize.height * ksize.height) + (ksize.width * ksize.width), 1 / 2) as double;
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: _notifier.isDarkModel()?ThemeMode.dark:ThemeMode.light,
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
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(false),
          trackVisibility: WidgetStateProperty.all(false),
          interactive: false,
          thickness: WidgetStateProperty.all(0.0),
        ),
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(false),
          trackVisibility: WidgetStateProperty.all(false),
          interactive: false,
          thickness: WidgetStateProperty.all(0.0),
        ),
        useMaterial3: false,
      ),
      home: _notifier.isTokenEmpty() ? const OnBoardingPageWidget() : const Dashboard(),
    );
  }
}
