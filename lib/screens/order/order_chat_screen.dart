import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:training_request/blocs/order_chat/bloc.dart';
import 'package:training_request/blocs/order_chat/event.dart';
import 'package:training_request/blocs/order_chat/state.dart';
import 'package:training_request/models/order_chat.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';

class OrderChatScreen extends StatefulWidget {
  final String bookingId;
  final String bookingTitle;

  const OrderChatScreen({
    Key? key,
    required this.bookingId,
    required this.bookingTitle,
  }) : super(key: key);

  @override
  State<OrderChatScreen> createState() => _OrderChatScreenState();
}

class _OrderChatScreenState extends State<OrderChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Join chat room when screen opens
    context.read<OrderChatBloc>().add(JoinChatRoom(bookingId: widget.bookingId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    // Leave chat room when screen closes
    context.read<OrderChatBloc>().add(LeaveChatRoom(bookingId: widget.bookingId));
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<OrderChatBloc>().add(
        SendChatMessage(
          message: message,
          bookingId: widget.bookingId,
        ),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: widget.bookingTitle,
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            AppText(
              text: 'Booking ID: ${widget.bookingId.substring(widget.bookingId.length - 5)}',
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<OrderChatBloc, OrderChatState>(
              builder: (context, state) {
                if (state is OrderChatLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColor.appColor),
                        SizedBox(height: 16),
                        AppText(
                          text: 'Connecting to chat...',
                          color: AppColor.grey,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  );
                }

                if (state is OrderChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        AppText(
                          text: state.message,
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        SizedBox(height: 16),
                        AppButton(
                          text: 'Retry',
                          onPressed: () {
                            context.read<OrderChatBloc>().add(
                              JoinChatRoom(bookingId: widget.bookingId),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

                if (state is OrderChatConnected) {
                  return _buildChatMessages(state.messages);
                }

                return Center(
                  child: AppText(
                    text: 'No messages yet',
                    color: AppColor.grey,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatMessages(List<OrderChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(OrderChatMessage message) {
    final isMe = message.isMe;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColor.appColor,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColor.appColor : AppColor.whitish,
                borderRadius: BorderRadius.circular(16),
                border: isMe ? null : Border.all(color: AppColor.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe) ...[
                    AppText(
                      text: message.senderName,
                      color: AppColor.appColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 4),
                  ],
                  AppText(
                    text: message.message,
                    color: isMe ? Colors.white : AppColor.black,
                    fontSize: 14,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    text: DateFormat('HH:mm').format(message.timestamp),
                    color: isMe ? Colors.white70 : AppColor.grey,
                    fontSize: 10,
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColor.appColor,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColor.grey.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.whitish,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColor.grey.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColor.appColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
} 