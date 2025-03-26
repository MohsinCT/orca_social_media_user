import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier{
  int _notificationCount = 0;

  int get notificationCount => _notificationCount;

  void updateNotificationCount(int count){
    _notificationCount = count;
    notifyListeners();
  }

  void resetNotificaionCount(){
    _notificationCount = 0;
    notifyListeners();
  }
}