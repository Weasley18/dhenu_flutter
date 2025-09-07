import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../services/chatbot_service.dart';

/// Environment configuration provider
final geminiApiKeyProvider = Provider<String>((ref) {
  // In a real app, this would be loaded from an environment variable or secure storage
  return 'YOUR_GEMINI_API_KEY'; // Replace with actual API key before running
});

/// Provider for the ChatbotService
final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  return ChatbotService(apiKey);
});

/// Provider for tracking whether the chatbot is initializing
final isChatbotInitializingProvider = StateProvider<bool>((ref) => true);

/// Provider for chat messages
final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier(ref);
});

/// Notifier for managing chat messages
class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;
  bool _isInitialized = false;

  ChatMessagesNotifier(this._ref) : super([]) {
    _initializeChatbot();
  }

  /// Initialize the chatbot and set the welcome message
  Future<void> _initializeChatbot() async {
    _ref.read(isChatbotInitializingProvider.notifier).state = true;
    
    try {
      final chatbotService = _ref.read(chatbotServiceProvider);
      await chatbotService.initialize();
      
      // Get the initial welcome message from the history
      final history = chatbotService.history;
      state = history;
      _isInitialized = true;
    } catch (e) {
      state = [
        ChatMessage.bot(
            "Sorry, I'm having trouble connecting. Please try again later."),
      ];
    } finally {
      _ref.read(isChatbotInitializingProvider.notifier).state = false;
    }
  }

  /// Send a message to the chatbot and get a response
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    if (!_isInitialized) {
      await _initializeChatbot();
    }

    try {
      final chatbotService = _ref.read(chatbotServiceProvider);
      
      // The sendMessage method of ChatbotService already updates its internal history
      // and returns the bot's response
      await chatbotService.sendMessage(message);
      
      // Update our state from the service's history
      state = chatbotService.history;
    } catch (e) {
      // If there's an error sending the message, add the user's message and an error message
      state = [
        ...state,
        ChatMessage.user(message),
        ChatMessage.bot(
            "Sorry, I encountered an error. Please try again later."),
      ];
    }
  }

  /// Clear the chat history
  void clearChat() {
    final chatbotService = _ref.read(chatbotServiceProvider);
    chatbotService.clearHistory();
    state = chatbotService.history;
  }
}
