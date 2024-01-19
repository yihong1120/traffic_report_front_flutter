import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimeOfDay(TimeOfDay? time) {
  if (time == null) {
    return 'Unknown time';
  }

  // 格式化时间为 HH:mm 格式
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return "$hours:$minutes";
}


