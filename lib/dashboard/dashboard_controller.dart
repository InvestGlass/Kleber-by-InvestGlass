import 'package:flutter/cupertino.dart';

class DashboardController extends ChangeNotifier{
  int selectedIndex=0;
  double iconSize=40;

  void changeIndex(int value) {
    selectedIndex=value;
    notifyListeners();
  }
}