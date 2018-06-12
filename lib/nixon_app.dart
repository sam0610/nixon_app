library nixon_app;

import 'dart:async';
import 'dart:convert';

import 'package:async_loader/async_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Models/Inspection.dart';

part 'Helper/AnimatedPageRoute.dart';
part 'Helper/authentication.dart';
part 'Helper/colors.dart';
part 'Helper/formHelper.dart';
part 'services/bldg_data.dart';
part 'services/inspection_Repo.dart';
part 'services/staff_data.dart';
part 'ui/InspectionForm/bldgDialog.dart';
part 'ui/InspectionForm/inspectionForm.dart';
part 'ui/InspectionForm/staffDialog.dart';
part 'ui/InspectionForm/viewCleaning.dart';
part 'ui/InspectionForm/viewInfo.dart';
part 'ui/InspectionForm/viewServices.dart';
part 'ui/InspectionForm/viewSummary.dart';
part 'ui/InspectionForm/widget.dart';
part 'ui/components/AnimatedCircularProgress.dart';
part 'ui/components/CheckBoxFormField.dart';
part 'ui/components/DateFormField.dart';
part 'ui/components/DropDownFormField.dart';
part 'ui/components/FormTextField.dart';
part 'ui/components/NumberFormField.dart';
part 'ui/components/Validator.dart';
part 'ui/components/SliderFormField.dart';
part 'ui/components/TimeFormField.dart';
part 'ui/homepage.dart';
part 'ui/login.dart';
part 'ui/splash_page.dart';
