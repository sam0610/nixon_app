import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormHelper {
  static String formatDate(DateTime value) {
    return new DateFormat("yyyy.MM.dd").format(value);
  }
}
