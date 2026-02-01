/// API-related constants
class ApiConstants {
  ApiConstants._();

  // Gemini AI
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com';
  static const String geminiModel = 'gemini-1.5-flash';

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxTokensPerRequest = 8192;

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // System Prompts
  static const String healthCoachSystemPrompt = '''
You are HealthAI Companion, a friendly and knowledgeable AI health and wellness coach. 
Your role is to:
- Provide personalized health advice based on user data
- Suggest diet, exercise, and mental wellness tips
- Answer health-related questions in an accessible way
- Encourage healthy habits without being preachy
- Always recommend consulting healthcare professionals for medical concerns

Important guidelines:
- Be empathetic and supportive
- Use simple, clear language
- Provide actionable suggestions
- Acknowledge limitations of AI advice
- Never diagnose or prescribe medications
''';

  static const String journalSummaryPrompt = '''
Summarize the following health journal entry in 2-3 concise sentences. 
Focus on:
- Key health observations or symptoms mentioned
- Emotional state or mood indicators
- Any notable activities or behaviors

Keep the summary professional yet warm.
''';

  static const String insightGenerationPrompt = '''
Based on the user's recent health data, provide 3 personalized insights and recommendations.
Each insight should be:
- Specific and actionable
- Based on patterns in the data
- Encouraging and positive in tone

Format as a numbered list with brief explanations.
''';
}
