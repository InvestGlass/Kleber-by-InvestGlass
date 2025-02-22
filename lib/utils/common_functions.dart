import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../dashboard/dashboard_controller.dart';
import '../documents/documents_controller.dart';
import '../home/home_controller.dart';
import '../login/login_controller.dart';
import '../login/on_boarding_page_widget.dart';
import '../main_controller.dart';
import '../market/market_controller.dart';
import '../portfolio/portfolio_controller.dart';
import '../profile/profile_controller.dart';
import '../proposals/proposal_controller.dart';
import '../securitySelection/security_selection_controller.dart';

enum EFontWeight {
  w100,
  w200,
  w300,
  w400,
  w500,
  w600,
  w700,
  w800,
  w900,
}

enum EAlign {
  left,
  center,
  right,
}

enum EDocumentType {
  document,
  form,
  package,
}

enum EProposalStatus {
  none,
  accepted,
  rejected,
}

enum EPermission {
  camera,
  imageFromGallery,
}

enum EAppTheme {
  light,
  dark,
  system,
}

enum ELanguageCode {
  en,
  ar,
  vi,
}

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,
  DataStruct,
  Enum,
}

class CommonFunctions {
  static showToast(String msg, {bool success = false}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: rSize * 0.016,
      timeInSecForIosWeb: 5,
      backgroundColor: success ? Colors.green : Colors.redAccent,
      textColor: Colors.white,
    );
  }

  static Map<String, dynamic> decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return {};
    }

    final payload = base64Url.decode(base64Url.normalize(parts[1]));
    final payloadMap = json.decode(utf8.decode(payload));

    return payloadMap;
  }

  static Future<String> downloadAndSavePdf(Uint8List bytes, String fileName, BuildContext context) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      String dir = '';
      if (Platform.isAndroid) {
        dir = '/storage/emulated/0/Download';
        final file = File('$dir/${fileName.replaceAll(':', '')}');
        print('path : $file');

        await file.writeAsBytes(bytes);
        return file.path;
      } else if (Platform.isIOS) {
        dir = (await getApplicationDocumentsDirectory()).path;
        final directory = await getTemporaryDirectory();
        final newFile = File("${directory.path}/${fileName.replaceAll(':', '')}");

        // if (await newFile.exists()) {
        //   await newFile.delete();
        // }
        await newFile.writeAsBytes(bytes);
        debugPrint('downloaded file path share+: ${newFile.path}');
        final box = context.findRenderObject() as RenderBox?;
        await Share.shareXFiles(
          [XFile(newFile.path)],
          subject: fileName,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
        // await Share.share('123');
        // return newFile.path;
        await newFile.delete();
        return '';
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  static showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: const Center(child: CircularProgressIndicator())),
    );
  }

  static dismissLoader(BuildContext context) {
    Navigator.pop(context);
  }

  static navigate(BuildContext context, Widget screen,
      {bool removeCurrentScreenFromStack = false, bool removeAllScreensFromStack = false, Function? onBack}) {
    if (removeCurrentScreenFromStack) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          )).then((value) {
        if (onBack != null) {
          onBack(value);
        }
      });
    } else if (removeAllScreensFromStack) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen), (Route<dynamic> route) => false);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen), (route) => false);
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ).then((value) {
        if (onBack != null) {
          onBack(value);
        }
      });
    }
  }

  static cleanAndLogout(BuildContext context) {
    SharedPrefUtils.instance.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MainController()),
            ChangeNotifierProvider(create: (_) => LoginController()),
            ChangeNotifierProvider(create: (_) => DashboardController()),
            ChangeNotifierProvider(create: (_) => PortfolioController()),
            ChangeNotifierProvider(create: (_) => ProfileController()),
            ChangeNotifierProvider(create: (_) => ProposalController()),
            ChangeNotifierProvider(create: (_) => MarketController()),
            ChangeNotifierProvider(create: (_) => DocumentsController()),
            ChangeNotifierProvider(create: (_) => HomeController()),
            ChangeNotifierProvider(create: (_) => SecuritySelectionController()),
          ],
          child: const OnBoardingPageWidget(),
        ),
      ),
      (Route<dynamic> route) => false, // Clear backstack
    );
  }

  static bool compare(String searchedWord, String text) {
    return text.toLowerCase().replaceAll(' ', '').contains(searchedWord.toLowerCase().replaceAll(' ', ''));
  }

  static String getYYYYMMDD(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDoubleWithThousandSeperator(
    String doubleStr,
    bool hideDecimalIfIs0,
    int numberOfDecimal,
  ) {
    hideDecimalIfIs0 = false;
    final value = double.tryParse(doubleStr.replaceAll(',', '')) ?? 0;
    if (value != 0 && value ~/ math.pow(10, 15) > 0) {
      return value.toStringAsPrecision(15);
    }
    String decimalStr = '';
    for (var i = 0; i < numberOfDecimal; i++) {
      decimalStr += (hideDecimalIfIs0 ? '#' : '0');
    }
    NumberFormat formatter = NumberFormat('#,##0.${decimalStr}', 'en_US');
    return formatter.format(value);
  }

}
