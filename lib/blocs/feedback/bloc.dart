import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/feedback.dart';
part 'event.dart';
part 'state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackRepository feedbackRepository;
  FeedbackBloc(this.feedbackRepository) : super(FeedbackState.initial()) {
    on<RatingChanged>((event, emit) {
      emit(state.copyWith(rating: event.rating));
    });

    on<CommentChanged>((event, emit) {
      emit(state.copyWith(comment: event.comment));
    });

    on<SubmitFeedback>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));

      try {
        // Simulated delay for submission
        await Future.delayed(Duration(seconds: 1));
        feedbackRepository.submitFeedback(
          bookingId: "bookingId",
          rating: state.rating,
          comments: state.comment,
        );
      } catch (_) {
        emit(state.copyWith(isSubmitting: false, error: 'Failed to submit.'));
      }
    });
  }
}
