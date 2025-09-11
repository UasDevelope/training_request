import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_chat/bloc.dart';
import '../blocs/order_chat/event.dart';
import '../blocs/order_chat/state.dart';

class ChatTestScreen extends StatefulWidget {
  const ChatTestScreen({Key? key}) : super(key: key);

  @override
  State<ChatTestScreen> createState() => _ChatTestScreenState();
}

class _ChatTestScreenState extends State<ChatTestScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _currentBookingId = 'test_booking_123';

  @override
  void initState() {
    super.initState();
    // Initialize chat for testing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderChatBloc>().add(ConnectToChat());
      context.read<OrderChatBloc>().add(JoinChatRoom(bookingId: _currentBookingId));
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<OrderChatBloc>().add(
        SendChatMessage(
          message: message,
          bookingId: _currentBookingId,
        ),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => OrderChatBloc(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Status indicator
              BlocBuilder<OrderChatBloc, OrderChatState>(
                builder: (context, state) {
                  String statusText = 'Initializing...';
                  Color statusColor = Colors.orange;

                  if (state is OrderChatLoading) {
                    statusText = 'Loading...';
                    statusColor = Colors.orange;
                  } else if (state is OrderChatConnected) {
                    statusText = 'Connected - ${state.messages.length} messages';
                    statusColor = Colors.green;
                  } else if (state is OrderChatError) {
                    statusText = 'Error: ${state.message}';
                    statusColor = Colors.red;
                  } else if (state is OrderChatDisconnected) {
                    statusText = 'Disconnected';
                    statusColor = Colors.grey;
                  }

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: statusColor, size: 12),
                        const SizedBox(width: 8),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Messages display
              Expanded(
                child: BlocBuilder<OrderChatBloc, OrderChatState>(
                  builder: (context, state) {
                    if (state is OrderChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is OrderChatConnected) {
                      if (state.messages.isEmpty) {
                        return const Center(
                          child: Text('No messages yet. Send a message to start!'),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(message.message),
                              subtitle: Text(
                                '${message.senderName} - ${message.timestamp.toString().substring(11, 16)}',
                              ),
                              trailing: message.isMe
                                  ? const Icon(Icons.person, color: Colors.blue)
                                  : const Icon(Icons.support_agent, color: Colors.green),
                            ),
                          );
                        },
                      );
                    }

                    if (state is OrderChatError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Error',
                              style: TextStyle(color: Colors.red[600], fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(color: Colors.red[500], fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<OrderChatBloc>().add(
                                  JoinChatRoom(bookingId: _currentBookingId),
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return const Center(
                      child: Text('Initializing chat...'),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Message input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    child: const Text('Send'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Test buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<OrderChatBloc>().add(
                          StartTyping(bookingId: _currentBookingId),
                        );
                      },
                      child: const Text('Start Typing'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<OrderChatBloc>().add(
                          StopTyping(bookingId: _currentBookingId),
                        );
                      },
                      child: const Text('Stop Typing'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

