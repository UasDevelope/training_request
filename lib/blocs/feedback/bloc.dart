import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/feedback.dart';
part 'event.dart';
part 'state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackRepository feedbackRepository;
  String? bookingId;
  
  FeedbackBloc(this.feedbackRepository, {this.bookingId}) : super(FeedbackState.initial()) {
    print('🔍 Feedback BLoC - Booking ID: $bookingId');
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
        print('🔍 Submitting feedback - Booking ID: ${bookingId ?? "unknown"}');
        await feedbackRepository.submitFeedback(
          bookingId: bookingId ?? "unknown",
          rating: state.rating,
          comment: state.comment,
        );
        
        emit(state.copyWith(isSubmitting: false, success: true));
      } catch (e) {
        print('❌ Feedback submission error: $e');
        emit(state.copyWith(isSubmitting: false, error: 'Failed to submit: $e'));
      }
    });
  }
}
