import 'package:flutter/material.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/widgets/app_text.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.onAction,
    this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with background circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColor.appColor).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: iconColor ?? AppColor.appColor,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            AppText(
              text: title,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            AppText(
              text: subtitle,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.light_grey,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 32),
              
              // Action button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.appColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: AppText(
                    text: actionText!,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Specific empty state widgets for different tabs
class PendingEmptyState extends StatelessWidget {
  const PendingEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: "No Pending Bookings",
      subtitle: "You don't have any pending training requests at the moment. Create a new booking to get started!",
      icon: Icons.schedule_outlined,
      iconColor: AppColor.blue,
    );
  }
}

class SubmittedEmptyState extends StatelessWidget {
  const SubmittedEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: "No Submitted Bookings",
      subtitle: "You haven't submitted any training requests yet. Submit a booking to see it here!",
      icon: Icons.send_outlined,
      iconColor: AppColor.appColor,
    );
  }
}

class InProgressEmptyState extends StatelessWidget {
  const InProgressEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: "No Active Sessions",
      subtitle: "You don't have any training sessions in progress right now. Accept a proposal to start training!",
      icon: Icons.directions_car_outlined,
      iconColor: Colors.orange,
    );
  }
}

class CompletedEmptyState extends StatelessWidget {
  const CompletedEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: "No Completed Sessions",
      subtitle: "You haven't completed any training sessions yet. Complete your first session to see it here!",
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    );
  }
}
