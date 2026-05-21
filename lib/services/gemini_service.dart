import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {

  static const String apiKey =
      "AIzaSyCMSEBZg_QaW7oewwGvpfuhWsSgVwRqjHo";

  Future<String> analyzePortfolio({
    required String portfolioData,
  }) async {

    try {

      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
      );

      final response = await http.post(

        url,

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "contents": [

            {
              "parts": [

                {
                  "text": """
Analyze this crypto portfolio:

$portfolioData

Give:
1. Portfolio risk
2. Best coin
3. Weak coin
4. Short investment suggestion

Keep response short.
"""
                }

              ]
            }

          ]

        }),
      );

      print("STATUS : ${response.statusCode}");
      print("BODY : ${response.body}");

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return data["candidates"][0]
        ["content"]["parts"][0]["text"];
      }

      return "Gemini API Error\n${response.body}";
    }

    catch (e) {

      return "Error : $e";
    }
  }
}