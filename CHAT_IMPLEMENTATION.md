# Order Chat Implementation

## Overview
This implementation adds real-time chat functionality to the training request app using BLoC pattern and Socket.IO.

## Features
- Real-time messaging between customers and drivers
- Order-specific chat rooms
- Socket.IO integration for live communication
- BLoC pattern for state management
- Chat button only shows for non-completed orders

## Architecture

### Models
- `OrderChatMessage`: Represents a chat message with sender info, timestamp, and status

### BLoC Components
- `OrderChatBloc`: Manages chat state and socket operations
- `OrderChatEvent`: Events for joining rooms, sending messages, etc.
- `OrderChatState`: States for loading, connected, error, etc.

### Screens
- `OrderChatScreen`: Main chat interface with message bubbles and input

### Socket Integration
- Uses `SocketService` for WebSocket communication
- Supports joining chat rooms by booking ID
- Handles real-time message sending and receiving

## Usage

### Adding Chat Button to Orders
The chat button is automatically added to order cards when the status is not "Completed":

```dart
if (item.status != "Completed") ...[
  AppButton(
    text: "Chat with Driver",
    onPressed: () {
      Navigator.pushNamed(
        context,
        AppRoutes.orderChat,
        arguments: {
          'bookingId': item.bookingId,
          'bookingTitle': 'Booking ${item.bookingId.substring(item.bookingId.length - 5)}',
        },
      );
    },
  ),
],
```

### Socket Events

#### Join Chat Room
```dart
socket.emit('joinRoom', { 'bookingId': 'booking_id' });
```

#### Send Message
```dart
socket.emit('chatMessage', {
  'bookingId': 'booking_id',
  'message': 'Your message here'
});
```

#### Receive Message
```dart
socket.on('chatMessage', (data) {
  // data: { _id, userId, senderName, senderRole, message, timestamp, status, bookingId }
});
```

## Dummy Data
Currently using dummy data for testing:
- Sample conversation between driver and customer
- Realistic timestamps and message flow
- Proper sender identification

## Future Enhancements
- Message persistence
- Read receipts
- Typing indicators
- File/image sharing
- Push notifications
- Message history loading

## Testing
To test the chat functionality:
1. Navigate to any order that's not completed
2. Tap the "Chat with Driver" button
3. Send messages and observe real-time updates
4. Check console logs for socket events 