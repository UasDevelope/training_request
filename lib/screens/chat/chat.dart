import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/chat_user/bloc.dart';
import 'package:training_request/blocs/chat_user/state.dart';
import 'package:training_request/core/app_routes.dart';

import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';

class ChatUsers extends StatelessWidget {
  const ChatUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<ChatUserBloc, ChatuserState>(
      builder: (context, state) {
        if (state is ChatUserLoadedState) {
          final chatList =
              state.chatUserModel; // Assume this is a list of ChatUserModel

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.chatInbox);
              },
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Center(child: Image.asset(AppImages.logo, height: 40)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: "Messages",
                          color: AppColor.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(AppImages.edit, height: 25, width: 25),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search message',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: chatList.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = chatList[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(user.imageUrl),
                            radius: 24,
                          ),
                          title: AppText(
                            text: user.userName,
                            color: AppColor.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          subtitle: Text(
                            user.lastMessage,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user.time, style: TextStyle(fontSize: 12)),
                              if (!user.isRead)
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "2",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
