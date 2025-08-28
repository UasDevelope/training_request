import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvents extends Equatable {
  const AuthEvents();
  List<Object> get props => [];
}

class CheckboxToggled extends AuthEvents {
  final bool isChecked;
  const CheckboxToggled({required this.isChecked});
  List<Object> get props => [isChecked];
}

class CheckTerms extends AuthEvents {
  final bool isTermChecked;
  const CheckTerms({required this.isTermChecked});
  List<Object> get props => [isTermChecked];
}

class SignupSubmitted extends AuthEvents {
  final String fullName;
  final String email;
  final String contactNumber;
  final String password;
  final String role;
  final String? drivingPermitNumber;
  final String? certificateNumber;

  SignupSubmitted({
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.password,
    required this.role,
    this.drivingPermitNumber,
    this.certificateNumber,
  });
}

class LoginRequest extends AuthEvents {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
  List<Object> get props => [email, password];
}

class LogoutRequest extends AuthEvents {
  const LogoutRequest();
  List<Object> get props => [];
}

class DeleteAccountRequest extends AuthEvents {
  const DeleteAccountRequest();
  List<Object> get props => [];
}
