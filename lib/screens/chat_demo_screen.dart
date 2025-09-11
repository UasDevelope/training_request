import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_chat/bloc.dart';
import '../blocs/order_chat/state.dart';
import 'chat_screen.dart';
import 'chat_test_screen.dart';

class ChatDemoScreen extends StatelessWidget {
  const ChatDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => OrderChatBloc(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Socket Chat Demo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Test different booking scenarios:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              
              // Test different booking statuses
              _buildChatButton(
                context,
                'Pending Booking (Chat Disabled)',
                'booking_pending_123',
                'This should show chat not available',
                Colors.orange,
              ),
              
              const SizedBox(height: 12),
              
              _buildChatButton(
                context,
                'Submitted Booking (Pre-service Chat)',
                'booking_submitted_456',
                'Chat with service providers',
                Colors.blue,
              ),
              
              const SizedBox(height: 12),
              
              _buildChatButton(
                context,
                'In Progress Booking (Service Chat)',
                'booking_inprogress_789',
                'Real-time service coordination',
                Colors.green,
              ),
              
              const SizedBox(height: 12),
              
              _buildChatButton(
                context,
                'Completed Booking (Post-service Chat)',
                'booking_completed_101',
                'Post-service follow-up',
                Colors.purple,
              ),
              
              const SizedBox(height: 32),
              
              // Connection status
              BlocBuilder<OrderChatBloc, OrderChatState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Connection Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getStatusText(state),
                          style: TextStyle(
                            color: _getStatusColor(state),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (state is OrderChatError) ...[
                          const SizedBox(height: 4),
                          Text(
                            state.message,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Tap any booking to open chat\n'
                      '• Messages are sent via Socket.IO\n'
                      '• Real-time updates and typing indicators\n'
                      '• Fallback to REST API if socket fails\n'
                      '• Location sharing for service providers',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatButton(
    BuildContext context,
    String title,
    String bookingId,
    String description,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              bookingId: bookingId,
              bookingTitle: title,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _getStatusText(OrderChatState state) {
    if (state is OrderChatLoading) {
      return '🔄 Connecting...';
    } else if (state is OrderChatConnected) {
      return '✅ Connected to chat room: ${state.bookingId}';
    } else if (state is OrderChatError) {
      return '❌ Connection error';
    } else if (state is OrderChatDisconnected) {
      return '🔌 Disconnected';
    } else {
      return '⏳ Initializing...';
    }
  }

  Color _getStatusColor(OrderChatState state) {
    if (state is OrderChatLoading) {
      return Colors.orange;
    } else if (state is OrderChatConnected) {
      return Colors.green;
    } else if (state is OrderChatError) {
      return Colors.red;
    } else if (state is OrderChatDisconnected) {
      return Colors.grey;
    } else {
      return Colors.blue;
    }
  }
}
