import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

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

class CommonFunctions{

  static showToast(String msg,{bool success=false}){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: success?Colors.green:Colors.redAccent,
      textColor: Colors.white,
    );
  }

  static Future<String> downloadAndSavePdf(Uint8List bytes,String fileName) async {
    try {
      /*final status = await Permission.storage.request();
      if (!status.isGranted) {
        // Handle permission denied
        CommonFunctions.showToast('Permission denied');
        return '';
      }*/
      String dir='';
      if(Platform.isAndroid) {
        dir = (await getExternalStorageDirectory())!.path;
      } else if(Platform.isIOS) {
        dir = (await getApplicationDocumentsDirectory()).path;
      }
      final file = File('$dir/$fileName');
      if (await file.exists()) {
        await file.writeAsBytes(bytes);
        return file.path;
      }
      // final response = await http.get(Uri.parse(url));
      return file.path;
    } catch (e) {
      print(e);
      return '';
    }
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
      {bool removeCurrentScreenFromStack = false,
        bool removeAllScreensFromStack = false,
        Function? onBack}) {
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => screen),
              (Route<dynamic> route) => false);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen), (route) => false);
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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

  static bool compare(String searchedWord,String text){
    return text.toLowerCase().replaceAll(' ', '').contains(searchedWord.toLowerCase().replaceAll(' ', ''));
  }

  static String getYYYYMMDD(DateTime date){
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDoubleWithThousandSeperator(
      String doubleStr,
      bool hideDecimalIfIs0,
      int numberOfDecimal,
      ) {
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