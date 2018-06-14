part of nixon_app;

String _validateField(dynamic oldvalue, dynamic value, InspectionModel model) {
  if (value != oldvalue) {
    model._formWasEdited = true;
  }
  if (value is String) {
    if (value == null || value.isEmpty) return 'can\'t be empty';
  }
  if (value is int) {
    if (value == null || value != -1 && value < 20) return 'can\'t be empty';
  }

  return null;
}
