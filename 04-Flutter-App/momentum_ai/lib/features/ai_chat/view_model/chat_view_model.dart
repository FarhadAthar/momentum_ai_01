import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/chat_model.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatState({this.messages = const [], this.isTyping = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isTyping}) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

final chatViewModelProvider = NotifierProvider<ChatViewModel, ChatState>(() {
  return ChatViewModel();
});

class ChatViewModel extends Notifier<ChatState> {
  Timer? _typingTimer;

  @override
  ChatState build() {
    // 👇 FIX: `dispose` ko hata kar `ref.onDispose` use kiya
    ref.onDispose(() {
      _typingTimer?.cancel();
    });

    // Initial AI greeting message
    final initialMessage = ChatMessage(
      id: '0',
      text:
          'Hi Ahmed! 👋 I\'m your AI productivity assistant. I can plan your day, reschedule tasks, analyze your week, and much more. What can I help you with?',
      isUser: false,
      timestamp: DateTime.now(),
    );
    return ChatState(messages: [initialMessage], isTyping: false);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // 1. Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, userMessage]);

    // 2. Show typing indicator
    state = state.copyWith(isTyping: true);

    // 3. Mock AI response after 1.5 seconds
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      final aiResponse = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}ai',
        text: _getMockResponse(text),
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, aiResponse],
        isTyping: false,
      );
    });
  }

  String _getMockResponse(String query) {
    if (query.toLowerCase().contains('work on right now')) {
      return 'Based on your schedule and energy patterns, start with the **client proposal** (due today 5 PM). You have a 90-minute deep work window before your 10 AM standup. Shall I block that time and silence notifications?';
    } else if (query.toLowerCase().contains('reschedule')) {
      return "Done! ✅\n• 8:00–9:30 AM → Deep Work: Client Proposal\n• Email review moved to 1:30 PM\n\nYour schedule is optimized. You've got this! 💪";
    } else {
      return "That's a great question! I'm analyzing your tasks right now. Let me check your calendar and get back to you with a tailored plan. 📅";
    }
  }
}
