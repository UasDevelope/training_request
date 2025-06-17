import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/inbox/bloc.dart';
import 'package:training_request/blocs/inbox/event.dart';
import 'package:training_request/blocs/inbox/state.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';

import '../../widgets/form_field.dart';

class ChatInbox extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                AppImages.person1,
              ), // Replace with your asset or network image
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppText(
                  text: "Orlando Diggs",

                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                AppText(text: "Online", fontSize: 12, color: Colors.green),
              ],
            ),
            // const Spacer(),
            // Icon(Icons.call_outlined, color: Colors.black),
            // const SizedBox(width: 16),
            // Icon(Icons.search, color: Colors.black),
            // const SizedBox(width: 8),
          ],
        ),
      ),
      body: BlocBuilder<ChatInboxBloc, ChatInboxState>(
        builder: (context, state) {
          if (state is ChatInboxLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatInboxLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: state.chatInbox.length,
                    itemBuilder: (context, index) {
                      final message = state.chatInbox[index];
                      return Align(
                        alignment:
                            message.isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color:
                                message.isMe
                                    ? AppColor.appColor
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(
                                message.isMe ? 16 : 0,
                              ),
                              bottomRight: Radius.circular(
                                message.isMe ? 0 : 16,
                              ),
                            ),
                          ),
                          child: AppText(
                          text:   message.message,
                           fontSize: 15,
                            fontWeight:FontWeight.w400,

                          ),
                        ),
                      );
                    },
                  ),
                ),
                // const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: _controller,
                          hintText: "Write you'r message",
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (_controller.text.trim().isNotEmpty) {
                            context.read<ChatInboxBloc>().add(
                              SendChatMessageEvent(
                                senderId: "user_2",
                                message: _controller.text.trim(),
                              ),
                            );
                            _controller.clear();
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            AppImages.send,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
