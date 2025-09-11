import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/user_profile_repository.dart';
import '../../api/api_exception.dart';

part 'event.dart';
part 'state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository userProfileRepository;
  
  UserProfileBloc(this.userProfileRepository) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    
    try {
      final userData = await userProfileRepository.getUserProfile();
      log('📱 User profile loaded: $userData');
      
      final user = userData['user'] ?? {};
      final userName = user['fullName'] ?? user['name'] ?? 'User';
      emit(UserProfileLoaded(userName: userName, userData: userData));
    } on BadExceptionRequest catch (e) {
      log('❌ User profile error: ${e.message}');
      emit(UserProfileError(message: e.message));
          } catch (e) {
        log('❌ User profile error: $e');
        emit(UserProfileError(message: 'Failed to load user profile'));
      }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event,
      Emitter<UserProfileState> emit,
    ) async {
      emit(UserProfileUpdating());
      
      try {
        final response = await userProfileRepository.updateUserProfile(
          fullName: event.fullName,
          contactNumber: event.contactNumber,
          email: event.email,
        );
        
        log('✅ User profile updated: $response');
        emit(UserProfileUpdated(message: response['message'] ?? 'Profile updated successfully'));
        
        // Reload the profile after update
        add(const LoadUserProfile());
      } on BadExceptionRequest catch (e) {
        log('❌ Update profile error: ${e.message}');
        emit(UserProfileError(message: e.message));
      } catch (e) {
        log('❌ Update profile error: $e');
        emit(UserProfileError(message: 'Failed to update profile'));
      }
    }
  }
