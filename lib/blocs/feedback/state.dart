part of 'bloc.dart';

class FeedbackState extends Equatable {
  final int rating;
  final String comment;
  final bool isSubmitting;
  final bool success;
  final String? error;

  const FeedbackState({
    required this.rating,
    required this.comment,
    required this.isSubmitting,
    required this.success,
    this.error,
  });

  factory FeedbackState.initial() => const FeedbackState(
    rating: 0,
    comment: '',
    isSubmitting: false,
    success: false,
    error: null,
  );

  FeedbackState copyWith({
    int? rating,
    String? comment,
    bool? isSubmitting,
    bool? success,
    String? error,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [rating, comment, isSubmitting, success, error];
}
