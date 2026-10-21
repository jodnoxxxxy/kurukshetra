const axios = require('axios');
// Removed OPENAI_API_KEY as we are now using Gemini

// A highly specialized context for the powerful agricultural bot
const SYSTEM_PROMPT = `
You are Kurukshetra Chatbot, an advanced, highly knowledgeable agricultural assistant powered by state-of-the-art AI.
Your main goal is to empower Indian farmers with highly accurate, data-driven, and actionable advice on:
- Crop recommendations based on soil NPK values, pH, humidity, and climate patterns.
- Early disease detection, exact mitigation strategies, and organic/chemical prevention methods.
- Yield optimization, precision fertilizer use (Urea, DAP, MOP), and integrated pest management (IPM).
- Hyper-local weather advisories, irrigation scheduling, and climate-smart farming techniques.
- Government agricultural schemes, MSP (Minimum Support Price) details, and market trends.

Guidelines for your responses:
1. Tone: Highly empathetic, encouraging, culturally deeply appropriate, and highly professional yet accessible.
2. Language: Respond in the language the farmer uses (e.g., Hindi, Marathi, English, Tamil, etc.). Use simple, clear language that a layman can understand.
3. Formatting: Use Markdown heavily! Use bold highlighting for important terms, bullet points for steps, and clear headings.
4. Accuracy: Do not guess. If you lack specific data, advise consulting local Krishi Vigyan Kendra (KVK) experts.
5. Actionable: Always give concrete next steps. Give specific measurements (e.g., "apply 50kg/acre") when standard practices apply.
`;

class ChatService {
  /**
   * Generates a response from the AI provider
   * @param {Array} history - Previous messages in the session
   * @param {string} newMessage - The latest user message
   * @returns {Promise<string>} - The AI response text
   */
  async generateResponse(history, newMessage) {
    try {
      const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
      if (!GEMINI_API_KEY) {
        // Fallback or mock if no key is provided
        return this._getMockResponse(newMessage);
      }

      // Map history for Gemini API
      const contents = [];
      const contextMessages = history.slice(-10);
      for (const msg of contextMessages) {
        contents.push({
          role: msg.isFromUser ? 'user' : 'model',
          parts: [{ text: msg.messageText }]
        });
      }

      contents.push({
        role: 'user',
        parts: [{ text: newMessage }]
      });

      const response = await axios.post(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`,
        {
          systemInstruction: {
            parts: [{ text: SYSTEM_PROMPT }]
          },
          contents: contents,
          generationConfig: {
            temperature: 0.5,
            topP: 0.9,
            maxOutputTokens: 800,
          }
        },
        {
          headers: {
            'Content-Type': 'application/json'
          }
        }
      );

      return response.data.candidates[0].content.parts[0].text;

    } catch (error) {
      console.error('AI Service Error:', error.response?.data || error.message);
      
      // If error is due to missing key / quota, fallback to conversational mock
      return "I'm experiencing a temporary connection issue to my knowledge base. Please try asking again shortly, or let me know if it's an emergency about your crops.";
    }
  }

  _getMockResponse(userMessage) {
    const text = userMessage.toLowerCase();
    
    if (text.includes('weather') || text.includes('rain')) {
      return "🌦️ **Weather Alert**: Based on general patterns, make sure your fields have proper drainage before heavy rains. I can provide more specific, hyper-local advice once my live connection is restored.";
    } else if (text.includes('fertilizer') || text.includes('npk') || text.includes('soil')) {
      return "🌱 **Soil & Fertilizers**: For precision fertilizer advice, it's best to know your soil's exact N, P, and K values. We generally recommend balanced NPK ratios, but once my connection is up, I can give you exactly the right formula for your crop!";
    } else if (text.includes('disease') || text.includes('pest') || text.includes('yellow')) {
      return "🐛 **Pest & Disease Control**: If you notice yellowing leaves or spots, it might be a fungal infection or pest attack. Consider immediately uploading a clear picture to our built-in **Disease Detection tool** or consulting a local KVK expert until I'm back online.";
    }
    
    return "🤖 **System Update**: I am currently operating in offline mode to optimize performance. Please configure the AI service key in the backend to unlock my full advanced agricultural knowledge base and personalized advice!";
  }
}

module.exports = new ChatService();
