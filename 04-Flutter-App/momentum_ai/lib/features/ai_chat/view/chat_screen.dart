import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/chat_view_model.dart';
import '../model/chat_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart,
      );
    }
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatViewModelProvider.notifier).sendMessage(text);
      _textController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
        );
      }
    });

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF7C3AED,
                          ).withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Assistant',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Online • GPT-4o powered',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // --- Chat List ---
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                // 👇 FIX: BOTTOM PADDING 140px kar diya hai
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 140,
                ),
                itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  final int reversedIndex = state.messages.length - 1 - index;

                  if (state.isTyping && index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _TypingIndicator(),
                      ),
                    );
                  }

                  final message = state.messages[reversedIndex];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _ChatBubble(message: message),
                  );
                },
              ),
            ),

            // --- Input Field ---
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.mic_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _handleSend,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 👇 FIX: YE LINE ADD KI HAI. Is se input field aur nav bar ke beech me 80px ka gap aayega
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// --- Chat Bubble Widget ---
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 10, top: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: message.isUser ? null : Colors.white,
                  gradient: message.isUser
                      ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        )
                      : null,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: message.isUser
                        ? const Radius.circular(20)
                        : const Radius.circular(4),
                    bottomRight: message.isUser
                        ? const Radius.circular(4)
                        : const Radius.circular(20),
                  ),
                  boxShadow: [
                    if (!message.isUser)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: message.isUser
                        ? Colors.white
                        : const Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- AI Typing Indicator ---
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
      child: Row(
        children: List.generate(3, (index) {
          final delay = index * 0.2;
          final animation = Tween<double>(begin: 0.4, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, delay + 0.4, curve: Curves.easeInOut),
            ),
          );
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF9CA3AF,
                  ).withValues(alpha: animation.value * 0.6),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
