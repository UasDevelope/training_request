import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';
import '../../blocs/feedback/bloc.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (context, state) {
          final bloc = context.read<FeedbackBloc>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 140),
                Image.asset(
                  AppImages.logo,
                  height: 60,
                ), // Replace with your ABCD image
                SizedBox(height: 20),
                AppText(
                  text: 'How is your training?',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8),
                AppText(
                  text: 'Your feedback will help improve service experience',
                  fontSize: 14,
                  color: Colors.grey[600],
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () => bloc.add(RatingChanged(index + 1)),
                      icon: Icon(
                        Icons.star,
                        color:
                            index < state.rating
                                ? Colors.orange
                                : Colors.grey[300],
                        size: 50,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                TextField(
                  maxLines: 4,
                  onChanged: (text) => bloc.add(CommentChanged(text)),
                  decoration: InputDecoration(
                    hintText: 'Additional comments',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed:
                      state.isSubmitting
                          ? null
                          : () => bloc.add(SubmitFeedback()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.appColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      state.isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : AppText(text: 'SUBMIT', color: Colors.white),
                ),
                SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
