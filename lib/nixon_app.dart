library nixon_app;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'Models/Inspection.dart';

part 'Helper/authentication.dart';
part 'ui/splash_page.dart';
part 'ui/login.dart';
part 'ui/homepage.dart';
part 'services/bldg_data.dart';
part 'ui/components/AnimatedCircularProgress.dart';
part 'services/inspection_Repo.dart';
part 'ui/inspectionForm.dart';
part 'ui/inspectionSummary.dart';
part 'Helper/formHelper.dart';
part 'Helper/AnimatedPageRoute.dart';
part 'Helper/colors.dart';
part 'ui/components/dateFormField.dart';
part 'ui/components/CheckBoxFormField.dart';
part 'ui/components/SliderFormField.dart';
part 'ui/components/timeFormField.dart';
part 'ui/components/FormTextField.dart';
part 'ui/components/DropdownFormField.dart';
