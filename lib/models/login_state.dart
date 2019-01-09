import 'package:meta/meta.dart';

class FieldValidation {
  final bool isValid;
  final String reason;

  const FieldValidation({
    @required this.isValid,
    @required this.reason,
  });
}

class ValidationState {}

class ValidationFinished extends ValidationState {

  final Map<String, FieldValidation> fields;

  bool get isFieldsValid => _isFieldsValid;
  bool _isFieldsValid;

  ValidationFinished({@required this.fields}) {
    _isFieldsValid = fields.values.every((vf) {
      return vf.isValid == true;
    });
  }
}

class ValidationLoading extends ValidationState {}

class ValidationInitial extends ValidationState {}