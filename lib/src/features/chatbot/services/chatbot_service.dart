import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

/// Placeholder for the GenerativeModel class
class GenerativeModel {
  final String model;
  final String apiKey;

  GenerativeModel({
    required this.model,
    required this.apiKey,
  });

  /// Start a chat session
  ChatSession startSession({
    List<ContentMessage>? history,
  }) {
    return ChatSession();
  }
}

/// Placeholder for the Content class
class ContentMessage {
  final String content;

  ContentMessage(this.content);

  /// Create a text content
  static ContentMessage fromText(String text) => ContentMessage(text);
}

/// Placeholder for the ChatSession class
class ChatSession {
  /// Send a message to the session
  Future<GenerativeResponse> sendMessage(ContentMessage content) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock responses based on user input
    final userText = content.content.toLowerCase();
    String response;
    
    if (userText.contains('hello') || userText.contains('hi')) {
      response = "Moo! Hello there! How can I help you today?";
    } else if (userText.contains('who are you') || userText.contains('what are you')) {
      response = "I'm Moo AI, a digital cow assistant. I'm here to answer questions about cows, agriculture, and rural life!";
    } else if (userText.contains('gir')) {
      response = "As a Gir cow, I'm known for my distinctive curved horns and red-spotted white coat. I'm from Gujarat and produce A2 milk that's very nutritious!";
    } else if (userText.contains('sahiwal')) {
      response = "Moo! As a Sahiwal cow, I'm a breed from Punjab, known for my heat tolerance and high milk production. I have a distinct reddish-brown color!";
    } else if (userText.contains('milk')) {
      response = "Cows like me produce milk that's full of calcium, protein, and essential vitamins. Good quality cow milk is used to make many dairy products like ghee, curd, and butter!";
    } else if (userText.contains('food') || userText.contains('eat')) {
      response = "I enjoy eating grass, hay, and plant-based food. A healthy cow like me eats about 50 kg of feed daily and drinks around 30-50 liters of water!";
    } else {
      response = "Moo! That's an interesting question. As a cow, I spend my days grazing, ruminating, and enjoying the sunshine. Is there anything specific about cows you'd like to know?";
    }
    
    return GenerativeResponse(response);
  }
}

/// Placeholder for the GenerativeResponse class
class GenerativeResponse {
  final String? _text;
  
  GenerativeResponse(this._text);
  
  String? get text => _text;
}

/// Service for handling chatbot interactions using mock AI
class ChatbotService {
  final GenerativeModel _model;
  final List<ChatMessage> _history = [];
  ChatSession? _chatSession;

  /// Create a new chatbot service with the specified model and API key
  ChatbotService(String apiKey, {String modelName = 'mock-model'})
      : _model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );

  /// Get the chat history
  List<ChatMessage> get history => List.unmodifiable(_history);

  /// Initialize the chat session with a system prompt
  Future<void> initialize() async {
    try {
      // Define the system prompt for the Moo AI persona
      const systemPrompt =
          "You are an Indian cow {breed}. Your default identity is that of a General Indian Cow. "
          "You will answer questions from the user from your perspective as a cow of this breed. "
          "If the user specifies a particular Indian cow breed (e.g., Gir, Sahiwal, Tharparkar, etc.), "
          "you will then adopt the characteristics and perspective of that specific breed and answer accordingly. "
          "Remember, the safety and welfare of all cows is paramount. We should be treated with kindness and respect. "
          "Be linient with the grammar and spellings. Answer in plain text, don't use markdown.";

      // Create a chat session with the system prompt
      final content = [ContentMessage.fromText(systemPrompt)];
      _chatSession = _model.startSession(
        history: content,
      );

      // Add a welcome message from the bot
      _history.add(ChatMessage.bot(
          "Hello! I'm Moo AI, your friendly cow companion. How can I help you today?"));
    } catch (e) {
      debugPrint('Error initializing chat session: $e');
      _history.add(ChatMessage.bot(
          "Sorry, I'm having trouble connecting to my brain. Please try again later."));
    }
  }

  /// Send a message to the chatbot and get a response
  Future<String> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      return '';
    }

    try {
      // Add the user message to history
      final userMessage = ChatMessage.user(message);
      _history.add(userMessage);

      // Get response from the model
      if (_chatSession == null) {
        await initialize();
      }

      final response = await _chatSession!.sendMessage(
        ContentMessage.fromText(message),
      );

      final botResponse = response.text?.trim() ?? 
          "Sorry, I couldn't generate a response. Please try again.";

      // Add the bot's response to history
      final botMessage = ChatMessage.bot(botResponse);
      _history.add(botMessage);

      return botResponse;
    } catch (e) {
      debugPrint('Error sending message: $e');
      final errorMessage =
          "Sorry, I encountered an error processing your message. Please try again.";
      
      // Add the error message to history
      _history.add(ChatMessage.bot(errorMessage));
      return errorMessage;
    }
  }

  /// Clear the chat history
  void clearHistory() {
    _history.clear();
    _chatSession = null;
    initialize();
  }
}