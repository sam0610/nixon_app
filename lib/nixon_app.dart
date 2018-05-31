library nixon_app;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:nixon_app/ui/inspectionList.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'Helper/AnimatedPageRoute.dart';
import 'Models/api.dart';
import 'ui/components/dropdown.dart';

part 'Helper/authentication.dart';
part 'ui/splash_page.dart';
part 'ui/login.dart';
part 'ui/homepage.dart';
part 'services/bldg_data.dart';
part 'ui/components/AnimatedCircularProgress.dart';
