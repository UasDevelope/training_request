import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/authentication/auth_event.dart';
import 'package:training_request/blocs/authentication/auth_state.dart';
import 'package:training_request/repositories/auth_repository.dart';

import '../../api/api_exception.dart';
import '../../services/local/storage.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitialState()) {
    on<CheckboxToggled>((event, emit) {
      log("checkox${event.isChecked}");
      emit(RememberChecked(isRememberMeChecked: event.isChecked));
    });
    on<CheckTerms>((event, emit) {
      log("Checkbox updated: ${event.isTermChecked}");
      emit(TermsChecked(isTermsChecked: event.isTermChecked));
    });
    on<SignupSubmitted>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final response = await authRepository.SignupUser(
          fullName: event.fullName,
          contactNumber: event.contactNumber,
          email: event.email,
          password: event.password,
          role: "user",
        );
        log("Response${response}");
        await LocalStorage.storeString(LocalStorage.AcessToken,response["token"]);
        emit(
          AuthSuccessState(message: response["message"] ?? "Signup successful"),
        );
      } on BadExceptionRequest catch (e) {
        emit(AuthErrorState(message: e.message)); // ← Your message is passed
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
    on<LoginRequest>((event, emit) async {
      emit(AuthLoadingState());

      try {
        var response = await authRepository.LoginUser(
          email: event.email,
          password: event.password,
        );
        emit(
          AuthSuccessState(message: response["message"] ?? "Login successful"),
        );
        log("Response${response}");
        await LocalStorage.storeString(LocalStorage.AcessToken,response["token"]);
      } on BadExceptionRequest catch (e) {
        emit(AuthErrorState(message: e.message));
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }
}
