part of 'bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

class UserProfileLoaded extends UserProfileState {
  final String userName;
  final Map<String, dynamic> userData;

  const UserProfileLoaded({
    required this.userName,
    required this.userData,
  });

  @override
  List<Object?> get props => [userName, userData];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserProfileUpdating extends UserProfileState {
  const UserProfileUpdating();
}

class UserProfileUpdated extends UserProfileState {
  final String message;

  const UserProfileUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}
