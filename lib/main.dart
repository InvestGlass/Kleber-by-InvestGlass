import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:freerasp/freerasp.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/flutter_flow_theme.dart';
import 'package:kleber_bank/utils/internationalization.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:package_info_plus/package_info_plus.dart' as info;
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'documents/documents_controller.dart';
import 'home/home_controller.dart';
import 'login/login_controller.dart';
import 'login/on_boarding_page_widget.dart';
import 'main_controller.dart';
import 'market/market_controller.dart';

double rSize = 0, btnHeight = 0;
bool isTablet = false;
late BuildContext globalContext;
late info.PackageInfo packageInfo;
late bool isPortraitMode;
late EdgeInsets padding;
BuildContext? c;
Timer? inactivityTimer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.createInstance();

  await FlutterFlowTheme.initialize();

  await FFLocalizations.initialize();
  WakelockPlus.enable();
  await _initializeTalsec();
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

Future<void> _initializeTalsec() async {
  info.PackageInfo packageInfo =await info.PackageInfo.fromPlatform();
  final config = TalsecConfig(
    androidConfig: AndroidConfig(
      packageName: 'com.aheaditec.freeraspExample',
      signingCertHashes: ['AKoRuyLMM91E7lX/Zqp3u4jMmd0A7hH/Iqozu0TMVd0='],
      supportedStores: ['com.sec.android.app.samsungapps'],
      malwareConfig: MalwareConfig(
        blacklistedPackageNames: ['com.aheaditec.freeraspExample'],
      ),
    ),
    iosConfig: IOSConfig(
      bundleIds: [packageInfo.packageName],
      teamId: '6YB8M77497',
    ),
    watcherMail: 'your_mail@example.com',
    isProd: kReleaseMode,
  );

  await Talsec.instance.start(config);
}

class MyApp extends riverpod.ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  riverpod.ConsumerState<riverpod.ConsumerStatefulWidget> createState()=>_MyAppState();
}

class _MyAppState extends riverpod.ConsumerState<MyApp> {
  late MainController _notifier;

  @override
  void initState() {
    Provider.of<MainController>(context,listen: false).resetTimer();
    getPackageInfo();
    super.initState();
  }

  Future<void> getPackageInfo() async {
    packageInfo = await info.PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _notifier = Provider.of<MainController>(context);
    isTablet = _isTablet(context);
    padding = MediaQuery.of(context).padding;
    isPortraitMode =
        (MediaQuery.of(context).orientation == Orientation.portrait);
    globalContext = context;
    Size ksize = MediaQuery.of(context).size;
    rSize =
        pow((ksize.height * ksize.height) + (ksize.width * ksize.width), 1 / 2)
            as double;
    btnHeight = rSize * 0.045;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _notifier.resetTimer,
      onPanDown: (_) => _notifier.resetTimer(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: _notifier.isDarkMode() ? ThemeMode.dark : ThemeMode.light,
        localizationsDelegates: const [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(
            SharedPrefUtils.instance.getString(SELECTED_LANGUAGE).isEmpty
                ? 'en'
                : SharedPrefUtils.instance.getString(SELECTED_LANGUAGE)),
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('vi'),
        ],
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(color: Colors.white),
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
          fontFamily: 'Roboto',
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all(false),
            trackVisibility: WidgetStateProperty.all(false),
            interactive: false,
            thickness: WidgetStateProperty.all(0.0),
          ),
          useMaterial3: false,
        ),
        home: SharedPrefUtils.instance.getString(USER_DATA).isEmpty
            ? const OnBoardingPageWidget()
            : const Dashboard(),
      ),
    );
  }

  bool _isTablet(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double shortestSide = size.shortestSide;

    // Check for tablet size based on shortest side and aspect ratio
    return shortestSide >= 600 && (size.width / size.height < 1.6);
  }
}
