part of 'bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  const LoadUserProfile();
}

class UpdateUserProfile extends UserProfileEvent {
  final String fullName;
  final String contactNumber;
  final String? email;

  const UpdateUserProfile({
    required this.fullName,
    required this.contactNumber,
    this.email,
  });

  @override
  List<Object?> get props => [fullName, contactNumber, email];
}
