/// Model representing a chat message in the chatbot interface
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  /// Create a user message
  static ChatMessage user(String text) {
    return ChatMessage(text: text, isUser: true);
  }

  /// Create a bot message
  static ChatMessage bot(String text) {
    return ChatMessage(text: text, isUser: false);
  }
}
