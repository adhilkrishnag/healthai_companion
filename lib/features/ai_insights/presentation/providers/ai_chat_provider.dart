import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../../core/constants/api_constants.dart';

/// Chat message model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

/// AI Chat state
class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// AI Chat provider
class AiChatNotifier extends StateNotifier<AiChatState> {
  GenerativeModel? _model;
  ChatSession? _chatSession;

  AiChatNotifier() : super(const AiChatState());

  /// Initialize Gemini model with API key
  Future<void> initialize(String apiKey) async {
    _model = GenerativeModel(
      model: ApiConstants.geminiModel,
      apiKey: apiKey,
      systemInstruction: Content.text(ApiConstants.healthCoachSystemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 2048,
      ),
    );
    _chatSession = _model!.startChat();
  }

  /// Send a message to the AI
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      String responseText;

      if (_chatSession != null) {
        // Use actual Gemini API
        final response = await _chatSession!.sendMessage(Content.text(message));
        responseText =
            response.text ??
            'I apologize, but I couldn\'t generate a response.';
      } else {
        // Demo mode - simulate AI response
        await Future.delayed(const Duration(seconds: 1));
        responseText = _generateDemoResponse(message);
      }

      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get response: ${e.toString()}',
      );
    }
  }

  /// Generate demo response when API key is not configured
  String _generateDemoResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('sleep')) {
      return '''Great question about sleep! Here are some tips to improve your sleep quality:

1. **Maintain a consistent schedule** - Go to bed and wake up at the same time daily
2. **Create a relaxing bedtime routine** - Read, meditate, or take a warm bath
3. **Limit screen time** - Avoid phones/tablets 1 hour before bed
4. **Optimize your environment** - Keep your room cool, dark, and quiet

Based on your recent sleep data, you're averaging 7.5 hours which is good! Would you like more specific recommendations?''';
    }

    if (lowerMessage.contains('exercise') || lowerMessage.contains('workout')) {
      return '''I'd be happy to help with exercise recommendations! Based on your profile:

**Suggested Weekly Plan:**
- 🏃 **Cardio**: 150 minutes moderate intensity (walking, cycling)
- 💪 **Strength**: 2-3 sessions targeting major muscle groups
- 🧘 **Flexibility**: Daily stretching or yoga

**Today's Quick Workout:**
- 10 min warm-up walk
- 20 bodyweight squats
- 15 push-ups (modified if needed)
- 30-second plank
- 10 min cool-down stretch

Would you like a more detailed exercise plan?''';
    }

    if (lowerMessage.contains('diet') ||
        lowerMessage.contains('food') ||
        lowerMessage.contains('eat')) {
      return '''Here are some nutrition tips tailored for your wellness goals:

**Key Recommendations:**
- 🥗 Fill half your plate with vegetables
- 🍎 Include 2-3 servings of fruit daily
- 💧 Drink at least 8 glasses of water
- 🥩 Choose lean proteins
- 🌾 Opt for whole grains over refined

**Foods to Limit:**
- Processed foods and sugary drinks
- Excessive sodium
- Trans fats

Would you like meal planning suggestions or recipes?''';
    }

    return '''Thank you for your question! As your HealthAI companion, I'm here to help with:

- 💤 Sleep optimization
- 🏃 Exercise recommendations
- 🥗 Nutrition guidance
- 🧘 Stress management
- 📊 Understanding your health metrics

Could you tell me more about what specific health topic you'd like to explore? I can provide personalized insights based on your tracked data.''';
  }

  /// Clear all messages
  void clearChat() {
    _chatSession = _model?.startChat();
    state = const AiChatState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider
final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((
  ref,
) {
  return AiChatNotifier();
});
