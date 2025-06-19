part of 'bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

class RatingChanged extends FeedbackEvent {
  final int rating;

  const RatingChanged(this.rating);

  @override
  List<Object?> get props => [rating];
}

class CommentChanged extends FeedbackEvent {
  final String comment;

  const CommentChanged(this.comment);

  @override
  List<Object?> get props => [comment];
}

class SubmitFeedback extends FeedbackEvent {}
